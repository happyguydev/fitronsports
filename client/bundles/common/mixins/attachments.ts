import Vue from 'vue';
import { Attachment } from '../attachments/interfaces/attachment';
import { Status } from '../interfaces';
import { parseError } from '../utils/errors';

const getFormDataSize = (data: FormData): number => {
  let size = 0;
  let pair;
  for(pair of data.entries()) {
    if(pair[1] instanceof Blob) {
      size += pair[1].size;
    } else {
      size += pair[1].length;
    }
  }
  return size;
};

const attachmentsMixin = Vue.extend({
  data: () => ({
    attachments: [] as Attachment[],
    status: 'idle' as Status,
    error: {} as Record<string, any>,
    valid: false,
    uploadPercentage: 0,
    uploading: false,
    uploadedCount: 0,
  }),
  methods: {
    uploadedImage(file: File) {
      console.log('Image file selected.');
      const attachment = {
        file,
        id: new Date().getTime().toString(),
        note: '',
        fileURL: '',
        destroyed: false,
        saved: false,
        blobId: '',
      };
      this.attachments.push(attachment);
    },
    directlyUploadedImageToS3(blobId: string, id: number) {
      this.attachments[id].blobId = blobId;
      this.uploadedCount++;
    },
    updatedAttachment(index: number, attachment: Attachment) {
      this.attachments[index] = { ...attachment };
    },
    removedAttachment(index: number) {
      if (!this.attachments[index].saved) {
        this.attachments.splice(index, 1);
        this.uploadedCount --;
      } else {
        this.attachments[index].destroyed = true;
      }
    },
    buildAttachments(targetName: string, data = new FormData()): FormData {
      this.attachments.forEach((attachment, index) => {
        data.append(
          `${targetName}[images_attachments][${index}][blob]`,
          attachment.blobId
        );
        data.append(
          `${targetName}[images_attachments][${index}][note]`,
          attachment.note
        );
      });

      return data;
    },
    async submit(formData: FormData): Promise<void> {
      this.status = 'pending';
      this.error = {};

      try {
        /**
         * [UPDATE] some browsers do not support upload-progress-callback
         * So now upload-progress is done by blind timer mode.
         * If browser supports upload-progress-callback, then it stops the timer and use that feature automatically.
         * But if not, then use timer, and increase progress without noticing real progress.
         */
        const sizeOfFormData = Math.round(getFormDataSize(formData) / 1000);
        console.log(`size of form data: ${sizeOfFormData} KB`);

        const manualUploader = setInterval(() => {
          this.uploadPercentage += 10;
          if (this.uploadPercentage >= 90) {
            clearInterval(manualUploader);
          }
        }, sizeOfFormData * 0.7);

        const config = {
          onUploadProgress: (e) => {
            // stops manual timer, and use the browser supported progress callback here.
            clearInterval(manualUploader);

            this.uploadPercentage = Math.round((e.loaded * 100) / e.total);
            console.log("uploading: ", this.uploadPercentage, e.loaded, e.total);
          },
          onDownloadProgress: (e) => {
            console.log("download starting ...");
            this.uploadPercentage = 100;
            this.uploading = false;
          },
        };
        console.log("start submit ...");
        // show upload progress modal
        this.uploadPercentage = 10;
        this.uploading = true;

        await this.$http.put(this.submissionUrl, formData, config);
        this.status = 'success';
        // @ts-ignore
        if (this.redirectPath && this.requestStatus === 'sent') {
          // @ts-ignore
          window.Turbolinks.visit(this.redirectPath);
        } else if (this.draftRedirectPath && this.requestStatus === 'draft') {
          window.location.replace(this.draftRedirectPath);
        }

        this.onSuccess();
      } catch (error) {
        const { message, validationErrors } = parseError(error);
        this.status = 'failure';
        this.error.message = message;
        this.error.messages = validationErrors;
      }
    },
    onSuccess() {},
  },
  computed: {
    submissionUrl(): string {
      // @ts-ignore
      return `${this.submissionPath}.json`;
    },
    attachedCount(): number {
      return this.attachments.length;
    },
  },
});

export { attachmentsMixin, getFormDataSize };
