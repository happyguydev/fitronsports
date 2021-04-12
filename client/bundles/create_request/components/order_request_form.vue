<template>
  <form @change="status = 'idle'" @submit="handleSubmit">
    <form-errors
      v-if="status === 'failure'"
      :error="error.message"
      :messages="error.messages"
    />

    <field-group :title="$t('product_order.page_title')" />

    <field-wrapper>
      <input
        type="text"
        :placeholder="$t('product_order.product_name')"
        v-model="title"
      />
    </field-wrapper>

    <quantity-stepper
      :label="$t('product_order.quantity')"
      v-model="quantity"
    />

    <field-wrapper>
      <textarea
        :placeholder="$t('placeholders.description')"
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
  name: 'OrderRequestForm',
  data: () => ({
    quantity: 0,
    productId: null as number | null,
    title: '',
    description: '',
    requestStatus: 'sent',
  }),
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
      formData.append(
        'create_request_form[product_quantity]',
        this.quantity.toString()
      );
      formData.append('create_request_form[description]', this.description);
      formData.append('create_request_form[title]', this.title);
      formData.append('create_request_form[status]', this.requestStatus);
      return formData;
    },
  },
  mounted() {
    this.$watch(
      () => [this.attachments, this.title],
      ([attachments, title]) => {
        this.valid = !!title && !isEmpty(attachments);
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
.wizard-actions {
  margin-top: 24px !important;
}
</style>
