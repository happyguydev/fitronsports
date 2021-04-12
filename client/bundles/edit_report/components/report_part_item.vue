<template>
  <article class="border border-grey-200 rounded-lg p-4 mb-3">
    <div class="flex flex-row items-center justify-between">
      <div class="flex flex-row justify-between items-center mb-1">
        <span class="text-base font-medium text-gray-800 pr-2">
          {{ this.reportPart.product_title }}
        </span>
        <span class="report-part__header-badge" :class="this.reportPart.rate" />
      </div>
      <button type="button" @click="editPart">
        <dots-icon />
      </button>
    </div>
    <div class="text-sm">
      {{ this.reportPart.description }}
    </div>
    <div class="mt-4 flex flex-row">
      <img
        v-for="attachment in this.reportPart.attachments"
        v-show="attachment.destroyed != true && attachment.note !== markOriginal"
        :key="attachment.id"
        :src="attachedImageUrl(attachment)"
        class="w-12 h-12 rounded-md object-cover mr-1"
      />
    </div>
  </article>
</template>

<script lang="ts">
import Vue, { PropOptions } from 'vue';
import { ReportPart } from '../interfaces/report_part';
import { Attachment, MARK_ORIGINAL } from '../../common/attachments/interfaces/attachment';

export default Vue.extend({
  name: 'ReportPartItem',
  props: {
    reportPart: {
      type: Object,
      required: true,
    } as PropOptions<ReportPart>,
    index: Number,
  },
  data: () => ({
    /* const variable */
    markOriginal: '',
  }),
  methods: {
    attachedImageUrl(attachment: Attachment): string {
      if (attachment.file != undefined) {
        return URL.createObjectURL(attachment.file);
      }
      return attachment.fileURL;
    },
    editPart() {
      this.$emit('editPart');
    },
  },
  created() {
    // initialize as const var
    this.markOriginal = MARK_ORIGINAL;
  },
});
</script>
