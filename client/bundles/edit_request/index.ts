/* eslint-disable no-underscore-dangle */
import 'bundles/common/vue_components';
import Vue from 'vue';
import VueI18n from 'vue-i18n';
import { set } from 'lodash';
import AttachmentsForm from '../common/attachments/attachments_form.vue';
import { Attachment } from '../common/attachments/interfaces/attachment';
import { Status } from '../common/interfaces';
import { useVueAxios } from '../common/vue_axios';
import { attachmentsMixin } from '../common/mixins/attachments';
import translation from '../common/translations';
import { Events, dispatchEvent } from '../common/utils/events';

useVueAxios();
Vue.use(VueI18n);

const I18nTranslation = new VueI18n({
  locale: I18nLocale,
  messages: translation,
  silentFallbackWarn: true,
});

export const initEditRequestForm = () => {
  document.addEventListener('turbolinks:load', () => {
    new Vue({
      el: '.edit_request',
      mixins: [attachmentsMixin],
      i18n: I18nTranslation,
      data: () => ({
        request: {
          title: '',
          description: '',
          status: 'sent',
          attachments_attributes: [] as Record<string, any>[],
        },
        attachments: [] as Attachment[],
        status: 'idle' as Status,
        error: {} as Record<string, any>,
      }),
      components: {
        AttachmentsForm,
      },
      methods: {
        removeFormAttachment(event: Event) {
          console.log("removeFormAttachment");
          const button = event.currentTarget as HTMLButtonElement;
          const { domId, attachmentIndex } = button.dataset;

          if (!domId || !attachmentIndex) {
            return;
          }

          const index = parseInt(attachmentIndex, 10);

          this.request.attachments_attributes[index] = {
            ...this.request.attachments_attributes[index],
            _destroy: true,
          };

          const item = this.$el.querySelector(`#${domId}`) as HTMLDivElement;
          if (!item) return;
          item.style.display = 'none';

          dispatchEvent(Events.attachmentUpdated, -1);
        },
        editRequest() {
          // @ts-ignore
          this.submit(this.formData);
        },
        onSuccess() {
          window.location.href = this.action;
        },
      },
      computed: {
        formData(): FormData {
          // const formData = new FormData();
          const formData = this.buildAttachments('request_images');
          formData.append('request[title]', this.request.title);
          formData.append('request[description]', this.request.description);
          formData.append('request[status]', this.request.status);

          this.request.attachments_attributes?.forEach((attachment, index) => {
            formData.append(
              `request_attached_images[images_attachments][${index}][id]`,
              attachment.id
            );
            formData.append(
              `request_attached_images[images_attachments][${index}][note]`,
              attachment.note
            );
            if (attachment._destroy === true) {
              formData.append(
                `request_attached_images[images_attachments][${index}][_destroy]`,
                attachment._destroy
              );
            }
          });

          return formData;
        },
        action(): string {
          return this.$el.getAttribute('action')!;
        },
        submissionUrl(): string {
          return `${this.action}.json`;
        },
      },
      beforeMount() {
        const inputs = this.$el.querySelectorAll('[v-model]');
        const data: any = {};
        inputs.forEach((input) => {
          const path = input.getAttribute('v-model')!;
          console.log("path: ", path);
          set(data, path, (input as HTMLInputElement).value);
        });
        this.request = data.request;
        this.request.status = 'sent';
        console.log("beforeMount: ", this.request);
      },
      mounted() {
        const btnSave = document.getElementById('edit_request_save');
        if (btnSave) {
          btnSave.addEventListener('click', () => {
            this.request.status = 'draft';
            console.log('save as draft clicked.');
          });
        }
      },
    });
  });
};
