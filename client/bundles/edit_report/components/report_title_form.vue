<template>
  <div class="flex flex-col">
    <h1 class="text-2xl mt-6 mb-12 font-bold">{{ isNotFirstTime ? $t('edit_report_title_facility') : $t('create_report_title') }}</h1>

    <h2 class="report_title__label info-block__detail mb-6 mt-3">{{ $t('report_title') }}</h2>
    <div class="field">
      <div class="field__wrapper string optional report_title">
        <input
          :placeholder="$t('placeholders.name_of_report')"
          aria-required="true"
          id="report-title"
          type="text"
          v-model="title"
          data-action="input->create-report#handleTitleInput"
          data-target="create-report.reporTitle"
        />
      </div>
    </div>

    <h2 class="facility__label info-block__detail mb-6 mt-2">{{ $t('facility_title') }}</h2>
    <input
      class="hidden"
      required="required"
      aria-required="true"
      placeholder="Facility"
      type="hidden"
      id="report_facility_id"
    />
    <button
      id="report_facility_select"
      type="button"
      class="field facility-input"
      data-action="create-report#openSearch"
      data-target="create-report.facilitySearch"
    >
      {{ facilityName }}
    </button>

    <div class="wizard-actions">
      <button
        @click="onCancelClick"
        type="button"
        class="button button--outline mr-6"
        v-show="!isNotFirstTime"
        :disabled="status === 'pending'"
      >
        {{ $t('actions.cancel') }}
      </button>
      <button
        id="report-submit"
        @click="onSubmitClick"
        type="button"
        class="button button--primary submit"
        :disabled="!valid || status === 'pending'"
      >
        {{ submissionButtonLabel }}
      </button>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  name: 'ReportInitForm',
  props: {
    status: String,
    homePath: String,
    propTitle: String,
    propFacilityId: String,
    propFacilityName: String,
    isNotFirstTime: Boolean,
    isUpdateReport: Boolean,
  },
  data: () => ({
    title: '',
    facilityId: '',
    facilityName: '',
    valid: false,
  }),
  methods: {
    onSubmitClick() {
      const facilityInput = document.getElementById(
        'report_facility_id'
      ) as HTMLInputElement;
      const facilitySelect = document.getElementById(
        'report_facility_select'
      ) as HTMLButtonElement;

      this.facilityId = facilityInput.value;
      this.facilityName = facilitySelect.textContent;
      this.resetSerializeStorage();
      this.$emit('submitTitleAndFacility', { ...this });
    },
    onCancelClick() {
      this.resetSerializeStorage();
      window.Turbolinks.visit(this.homePath);
      // this.$emit('cancelTitleForm');
    },
    serializeForm() {
      const reportData = {
        title: this.title,
      };
      sessionStorage.setItem('fitron-report', JSON.stringify(reportData));
      sessionStorage.setItem('fitron-report-flag', 'draft');
    },
    deserializeForm() {
      const hasSavedBefore = sessionStorage.getItem('fitron-report-flag');
      if (!hasSavedBefore) return;
      const reportData = JSON.parse(sessionStorage.getItem('fitron-report'));
      this.title = reportData.title;
    },
    resetSerializeStorage() {
      sessionStorage.removeItem('fitron-report-flag');
      sessionStorage.removeItem('fitron-sport');
    },
  },
  mounted() {
    this.title = this.propTitle;
    this.facilityId = this.propFacilityId;
    this.facilityName = this.propFacilityName;

    const facilityInput = document.getElementById(
      'report_facility_id'
    ) as HTMLInputElement;
    facilityInput.value = this.facilityId;
/*
    const facilitySelect = document.getElementById(
      'report_facility_select'
    ) as HTMLButtonElement;
    if (facilitySelect) {
      facilitySelect.addEventListener('click', () => {
        this.serializeForm();
      });
    }

    this.$watch(
      () => [this.title, this.facilityId],
      ([title, facilityId]) => {
        this.valid = !!title && facilityId >= 0;
      },
      {
        immediate: true,
        deep: true,
      }
    );
*/
  },
  computed: {
    submissionButtonLabel() {
      if (!this.isNotFirstTime) {
        return this.$t('actions.create');
      }
      return this.isUpdateReport
        ? this.$t('actions.update')
        : this.$t('actions.continue');
    },
  },
};
</script>
