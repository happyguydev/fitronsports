<template>
  <form class="form" @change="status = 'idle'" @submit="handleSubmit">
    <form-errors
      v-if="status === 'failure'"
      :error="error.message"
      :messages="error.messages"
    />

    <field-group :title="$t('service_request.page_title')" />

    <field-wrapper>
      <input
        type="text"
        :placeholder="$t('placeholders.title')"
        v-model="title"
      />
    </field-wrapper>

    <field-wrapper>
      <textarea
        :placeholder="$t('placeholders.description')"
        class="description"
        v-model="description"
      />
    </field-wrapper>

    <AttachmentsForm
      :attachments="attachments"
      s3Directory="requests"
      :isMandatory="true"
      @on-image="uploadedImage"
      @on-directly-uploaded="directlyUploadedImageToS3"
      @updated-attachment="updatedAttachment"
      @removed-attachment="removedAttachment"
    />
    <mandatory-hint />
    <RequestFormActions
      class="mt-6"
      :valid="valid && attachedCount===uploadedCount"
      :status="status"
      :cancelRequestPath="cancelPath"
      @save-as-draft="handleSubmitDraft"
    />
    <UploadProgress :percent="uploadPercentage" v-if="uploading" />
  </form>
</template>

<script lang="ts">
import mixins from 'vue-typed-mixins';
import { isEmpty } from 'lodash';
import AttachmentsForm from '../../common/attachments/attachments_form.vue';
import { attachmentsMixin } from '../../common/mixins/attachments';
import RequestFormActions from './request_form_actions.vue';
import UploadProgress from '../../common/attachments/upload-progress.vue';

export default mixins(attachmentsMixin).extend({
  name: 'ServiceRequestForm',
  components: {
    AttachmentsForm,
    RequestFormActions,
    UploadProgress,
  },
  props: {
    redirectPath: String,
    draftRedirectPath: String,
    submissionPath: String,
    cancelPath: String,
  },
  data: () => ({
    title: '',
    description: '',
    requestStatus: 'sent',
  }),
  methods: {
    handleSubmit(event: Event) {
      event.preventDefault();
      this.submit(this.formData);
    },
    handleSubmitDraft() {
      this.requestStatus = 'draft';
      this.submit(this.formData);
    },
  },
  computed: {
    formData(): FormData {
      const formData = this.buildAttachments('create_request_form');
      formData.append('create_request_form[title]', this.title);
      formData.append('create_request_form[description]', this.description);
      formData.append('create_request_form[status]', this.requestStatus);
      return formData;
    },
  },
  mounted() {
    this.$watch(
      () => [this.title, this.description, this.attachments, this.status],
      (items) => {
        this.valid = items.every((item) => !isEmpty(item));
      },
      {
        immediate: true,
        deep: true,
      }
    );
  },
});
</script>

<style lang="scss" scoped>
.description {
  min-height: 144px;
}

textarea {
  min-height: 144px;
  @apply outline-none w-full h-full;

  &:focus {
    @apply outline-none;
  }

  &::placeholder {
    color: rgba(128, 128, 128, 0.6);
  }
}

.submit {
}

.error-alert {
  @apply flex flex-col;
}

.errors {
  @apply mt-3 list-disc list-inside;
  @apply capitalize;
}

.wizard-actions {
  margin-top: 24px !important;
}
</style>
