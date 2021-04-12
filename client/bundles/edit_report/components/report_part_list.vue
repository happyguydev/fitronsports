<template>
  <div class="flex flex-col flex-wrap report-part-list">
    <div
      class="flex flex-row justify-between items-center report-part-list__header"
    >
      <h1 class="report-part-list__title">{{ $t('part_list') }}</h1>
      <button
        type="button"
        class="report-part-list__add-action"
        :class="isEditableReport && 'active'"
        @click="onAddNewPartClick"
      >
        {{ $t('add_part') }}
      </button>
    </div>

    <ReportPartItem
      v-for="(reportPart, index) in this.partsList"
      v-show="!reportPart.destroyed"
      :reportPart="reportPart"
      :index="index"
      :key="index"
      @editPart="onEditPartClick(index, reportPart)"
    />

    <div
      class="wizard-actions"
      id="report-part-list-actions"
      v-show="isValidSubmit && isEditableReport"
    >
      <button
        @click="onSaveAsDraftClick"
        type="button"
        class="button button--outline mr-3"
        :disabled="status === 'pending'"
      >
        {{ saveButtonLabel }}
      </button>
      <button
        @click="onSubmitSignClick"
        type="button"
        class="button button--primary submit ml-3"
        :disabled="status === 'pending'"
      >
        {{ $t('actions.sign_submit') }}
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import ReportPartItem from './report_part_item.vue';
import { IReportPart } from '../interfaces/report_part';

export default {
  name: 'ReportPartList',
  components: {
    ReportPartItem,
  },
  props: {
    status: String,
    submitType: String,
    isValidSubmit: Boolean,
    isEditableReport: Boolean,
    partsList: {
      type: Array,
    },
  },
  methods: {
    onAddNewPartClick() {
      if (this.isEditableReport) {
        this.$emit('clickAddNewPart');
      }
    },
    onSaveAsDraftClick() {
      this.$emit('clickSaveAsDraft');
    },
    onSubmitSignClick() {
      this.$emit('clickSignature');
    },
    onEditPartClick(index: number, reportPart: IReportPart) {
      if (this.isEditableReport) {
        this.$emit('clickEditPart', index, reportPart);
      }
    },
  },
  computed: {
    saveButtonLabel(): string {
      if (this.status === 'pending' && this.submitType === 'draft') {
        return this.$t('actions.saving');
      }
      return this.$t('actions.save');
    },
  },
};
</script>

<style lang="scss" scoped>
  .report-part-list {
    &__header {
      @apply mt-6 mb-4 text-base;
    }

    &__title {
      @apply font-bold;
    }
    &__add-action {
      @apply text-gray-500;
    }
    &__add-action.active {
      @apply text-primary-500;
    }
  }
</style>
