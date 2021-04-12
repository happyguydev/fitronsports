<template>
  <div class="report-part-editor">
    <div class="flex flex-row justify-between items-center py-3 border-b">
      <h1 class="text-base font-medium">
        {{ isUpdate ? $t('report_part_editor.edit_page_title') : $t('report_part_editor.page_title') }}
      </h1>

      <button type="button" aria-label="Close" @click="close" v-show="isUpdate">
        <clear-icon />
      </button>
    </div>

    <field-group :title="$t('report_part_editor.header')" class="mt-8" />

    <ProductSelect :selected="product_title" @input="onProductChange" />

    <field-wrapper>
      <textarea
        :placeholder="$t('report_part_editor.part_description')"
        class="description"
        v-model="description"
      />
    </field-wrapper>

    <AttachmentsForm
      s3Directory="report_parts"
      :attachments="attachments"
      @on-image="uploadedImage"
      @on-directly-uploaded="directlyUploadedImageToS3"
      @updated-attachment="updatedAttachment"
      @removed-attachment="removedAttachment"
    />

    <field-group
      :title="$t('report_part_editor.rate_condition')"
      class="mt-8"
    />
    <div class="flex flex-row justify-between">
      <rate-good @activated="setRate('good')" :active="this.rate === 'good'" />
      <rate-problematic
        @activated="setRate('problematic')"
        :active="this.rate === 'problematic'"
      />
      <rate-bad @activated="setRate('bad')" :active="this.rate === 'bad'" />
    </div>
    <mandatory-hint />
    <div class="wizard-actions" data-after-wizard-hint="true">
      <button
        @click="onClickCancel"
        type="button"
        class="button button--outline mr-3"
        v-show="!isUpdate"
      >
        {{ $t('actions.cancel') }}
      </button>
      <button
        @click="onClickDelete"
        type="button"
        class="button button--outline mr-3"
        v-show="isUpdate"
      >
        {{ $t('actions.delete') }}
      </button>
      <button
        @click="onClickSubmit"
        type="button"
        class="button button--primary submit ml-3"
        :disabled="!valid || status === 'pending' || attachedCount!== uploadedCount"
      >
        {{ isUpdate ? $t('actions.save') : $t('actions.add') }}
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import { PropOptions } from 'vue';
import mixins from 'vue-typed-mixins';
import { isEmpty } from 'lodash';
import AttachmentsForm from '../../common/attachments/attachments_form.vue'
import { attachmentsMixin } from '../../common/mixins/attachments';
import { IReportPart, ReportPart } from '../interfaces/report_part';
import { Attachment } from '../../common/attachments/interfaces/attachment';
import { Product } from '../../common/interfaces/product';
import ProductSelect from '../../common/products/product_select.vue';

export default mixins(attachmentsMixin).extend({
  name: 'ReportPartEditor',
  components: {
    AttachmentsForm,
    ProductSelect,
  },
  props: {
    reportPart: {
      type: Object,
    } as PropOptions<IReportPart>,
    index: Number,
  },
  data: () => ({
    id: '',
    title: '',
    description: '',
    rate: '',
    product: null as null | Product,
    product_id: -1,
    product_title: '',
    attachments: [] as Attachment[],
    isUpdate: false,
  }),
  methods: {
    close() {
      this.resetStatus();
      this.$emit('close');
    },
    resetStatus() {
      Object.assign(this.$data, { ...new ReportPart(), product: null });
    },
    setRate(r: string) {
      this.rate = r;
    },
    onClickCancel() {
      this.close();
    },
    onClickDelete() {
      this.$emit('deleteReportPart', this.index);
      this.resetStatus();
    },
    onProductChange(product: Product) {
      this.product = product;
      this.product_id = this.product.id;
      this.product_title = this.product.title;
    },
    onClickSubmit() {
      const reportPartData = { ...this.$data };
      console.log("report part data:", reportPartData);
      this.$emit('submitReportPart', this.index, reportPartData);
      this.resetStatus();
    },
  },
  mounted() {
    this.$watch(
      () => [this.description, this.rate, this.product_title],
      (items) => {
        this.valid = items.every((item) => !isEmpty(item));
      },
      {
        immediate: true,
        deep: true,
      }
    );
  },
  created() {
    Object.assign(this.$data, this.reportPart);
    this.isUpdate = !!this.product_title;
  },
});
</script>
