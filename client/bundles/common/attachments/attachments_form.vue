<template>
  <div class="attachments-form">
    <div class="attachments-list">
      <Attachment
        v-for="(attachment, index) in attachments"
        v-show="!attachment.destroyed && attachment.note !== markOriginal"
        :key="attachment.id"
        :attachment="attachment"
        :index="index"
        :uploading="!attachment.saved && attachment.blobId === ''"
        @updated="updatedAttachment"
        @remove="removeAttachment"
        @detail="showAttachmentModal"
        @edit="showImageEditor"
      />
    </div>
    <label class="add-attachment">
      <PhotoIcon class="add-attachment__icon" />
      {{ $t('actions.add_photo') }} {{ isMandatory ? ' *' : '' }}
      <input
        type="file"
        ref="file"
        class="hidden"
        accept="image/*"
        @change="handleFileUpload"
        @click="resetFileUpload"
      />
    </label>

    <AttachmentView
      v-if="isDetailModalVisible"
      :attachmentUrl="selectedAttachmentUrl"
      @close="closeAttachmentModal"
    />
    <AttachmentEditor
      v-if="isImageEditorVisible"
      :attachmentUrl="selectedAttachmentUrl"
      :attachmentWidth="reducedImageWidth"
      :attachmentHeight="reducedImageHeight"
      @close="closeImageEditor"
      @applyEdit="saveEditorResult"
    />
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { isEmpty } from 'lodash';
import PhotoIcon from './photo_icon.vue';
import Attachment from './attachment.vue';
import AttachmentView from './attachment_view.vue';
import AttachmentEditor from './attachment_editor.vue';
import {
  Attachment as IAttachment,
  MARK_ORIGINAL,
} from './interfaces/attachment';
import { dataURItoBlob } from '../utils/signature';
import { Events, dispatchEvent } from '../utils/events';
import { calculateMD5 } from '../utils/md5';

export default Vue.extend({
  name: 'AttachmentsForm',
  props: {
    attachments: {
      type: Array,
      required: true,
    },
    isMandatory: {
      type: Boolean,
      default: false,
    },
    s3Directory: {
      type: String,
      required: true,
    }
  },
  components: {
    PhotoIcon,
    Attachment,
    AttachmentView,
    AttachmentEditor,
  },
  data: () => ({
    isDetailModalVisible: false,
    isImageEditorVisible: false,

    selectedAttachmentUrl: '',
    selectedIndex: -1,
    selectedAttachment: {},

    reducedImageWidth: 0,
    reducedImageHeight: 0,
    /* const variable */
    markOriginal: '',
  }),
  methods: {
    /**
     * getPresignedUrl()
     * AWS S3 Direct upload methods
     * invoke backend endpoint, and get presigned_url of S3
     */
    async getPresignedUrl(file: File): Promise<any> {
      const md5 = await calculateMD5(file);
      const md5Base64 = btoa(md5);
      console.log('getting presigned url for direct upload');
      console.log('md5 hash:', md5Base64);
      try {
        const blobData = {
          file: {
            byte_size: file.size,
            filename: file.name,
            checksum: md5Base64,
            content_type: file.type || 'image/png',
            metadata: {
              message: `attachment ${file.name}`,
            },
          },
          url: {
            expiration_time: 600,
            folder: `uploads_v2/${this.s3Directory}/${new Date().toISOString().slice(0,10)}`,
          },
        };
        return await this.$http.post('/direct-upload', blobData);
      } catch (e) {
        console.log('error while getting presigned url');
      }
      return null;
    },
    /**
     * directUploadFileToAws()
     * AWS S3 Direct upload methods
     */
    async directUploadFileToAws(presignedInfo: any, file: File) {
      try {
        const res = await this.$http.put(presignedInfo.direct_upload.url, file);
        return res.status;
      } catch (e) {
        console.log('error while uploading file into AWS');
      }
      return null;
    },
    /**
     * applyS3DirectUpload()
     * process direct upload
     */
    async applyS3DirectUpload(file: File, appendIndex: number): Promise<string | null> {
      const res = await this.getPresignedUrl(file);
      if (res === null) {
        console.log('failed to get presigned url.');
        return null;
      }
      console.log('blob_signed_id: ', res.data.blob_signed_id);
      const res2 = await this.directUploadFileToAws(res.data, file);
      console.log('direct upload status: ', res2);
      if (res2 !== 200) {
        // not succeeded upload, then return
        console.log('direct upload failed.');
        return null;
      }
      return { blobId: res.data.blob_signed_id, appendIndex };
    },
    async handleFileUpload() {
      const fileRef = this.$refs.file as HTMLInputElement;
      const file = fileRef.files![0];
      // first: trying to upload into S3
      this.applyS3DirectUpload(file, this.attachments.length).then((res) => {
        if (!res) return;
        this.$emit('on-directly-uploaded', res.blobId, res.appendIndex);
      });
      this.$emit('on-image', file);

      /**
       * edit-request is server side rendering.
       * And attachment is mandatory there.
       * To implement validation check in edit-request view, I've used CustomEvent to send notification that attachment is changed.
       */
      dispatchEvent(Events.attachmentUpdated, 1);
    },
    resetFileUpload() {
      (this.$refs.file as HTMLInputElement).value = '';
    },
    updatedAttachment(index: number, attachment: IAttachment) {
      this.$emit('updated-attachment', index, attachment);
    },
    removeAttachment(index: number) {
      this.$emit('removed-attachment', index);

      dispatchEvent(Events.attachmentUpdated, -1);
    },
    showAttachmentModal(preview: string) {
      this.hideWizardActions();
      this.selectedAttachmentUrl = preview;
      this.isDetailModalVisible = true;
    },
    closeAttachmentModal() {
      this.isDetailModalVisible = false;
      this.showWizardActions();
    },
    showImageEditor(
      index: number,
      attachment: IAttachment,
      width: number,
      height: number
    ) {
      this.hideWizardActions();

      this.selectedIndex = index;
      this.selectedAttachment = attachment;
      this.selectedAttachmentUrl = URL.createObjectURL(attachment.file);
      if (
        width < window.screen.width * 0.8 &&
        height < window.screen.height * 0.8
      ) {
        this.reducedImageWidth = width;
        this.reducedImageHeight = height;
      } else {
        const reduceRate = Math.max(
          width / window.screen.width,
          height / window.screen.height
        );
        this.reducedImageWidth = Math.round((width * 0.8) / reduceRate);
        this.reducedImageHeight = Math.round((height * 0.8) / reduceRate);
      }

      this.isImageEditorVisible = true;
    },
    closeImageEditor() {
      this.isImageEditorVisible = false;
      this.showWizardActions();
    },
    saveEditorResult(dataURL: string) {
      console.log("save edit result");
      console.log("original attachment note", this.attachments[this.selectedIndex].note);

      const file = new File(
        [dataURItoBlob(dataURL)],
        `__edited__${this.selectedAttachment.file.name}`
      );
      // first: trying to upload into S3
      this.applyS3DirectUpload(file, this.selectedIndex + 1).then((res) => {
        if (!res) return;
        this.$emit('on-directly-uploaded', res.blobId, res.appendIndex);
      });
      const newAttachment = {
        file,
        id: new Date().getTime().toString()+"_edited_",
        note: this.attachments[this.selectedIndex].note,
        fileURL: '',
        destroyed: false,
        saved: false,
        blobId: '',
      };
      // add edited image as another attachment
      this.attachments.splice(this.selectedIndex + 1, 0, newAttachment);
      // and make a sign as original, in order to distinguish from edited image
      this.attachments[this.selectedIndex].note = this.markOriginal;
      this.closeImageEditor();
    },
    showWizardActions() {
      const wizardActions = document.querySelector('.wizard-actions');
      if (wizardActions) {
        wizardActions.classList.remove('hidden-always');
      }
    },
    hideWizardActions() {
      const wizardActions = document.querySelector('.wizard-actions');
      if (wizardActions) {
        wizardActions.classList.add('hidden-always');
      }
    },
  },
  computed: {
    hasAttachments() {
      return !isEmpty(this.attachments);
    },
  },
  created() {
    // initialize as const var
    this.markOriginal = MARK_ORIGINAL;
  },
});
</script>

<style lang="scss" scoped>
.add-attachment {
  @apply flex flex-row transition-all ease-in-out duration-200;
  @apply cursor-pointer;
  @apply font-medium text-primary-500;

  &__icon {
    margin-right: 10.5px;
  }

  &:hover {
    @apply opacity-75;
  }
}
</style>
