<template>
  <div class="flex flex-col">
    <ReportTitleForm
      :status="formStatus"
      :homePath="homePath"
      :propTitle="title"
      :propFacilityName="facilityName"
      :propFacilityId="facilityId"
      :isNotFirstTime="false"
      :isUpdateReport="false"
      @submitTitleAndFacility="onSubmitTitleAndFacility"
    />
  </div>
</template>

<script lang="ts">
import { parseError } from '../../common/utils/errors';
import ReportTitleForm from '../../edit_report/components/report_title_form.vue';

export default {
  name: 'ReportForm',
  components: {
    ReportTitleForm,
  },
  props: {
    submissionPath: String,
    submissionMethod: String,
    cancelPath: String,
    homePath: String,
  },
  data: () => ({
    title: '',
    facilityId: '',
    facilityName: '',
    createdDate: '',
    reportStatus: 'draft',
    formStatus: 'idle',
  }),
  methods: {
    hideTopNavs() {
      const headerNav = document.querySelector('.dashboard-header');
      if (headerNav) {
        headerNav.classList.add('hidden-always');
      }
      const dashboardWrapper = document.querySelector('.dashboard-wrapper');
      if (dashboardWrapper) {
        dashboardWrapper.classList.remove('dashboard-wrapper--with-toolbar');
        dashboardWrapper.dataset.headerVisible = false;
      }
    },
    onSubmitTitleAndFacility(initData: any) {
      this.title = initData.title;
      this.facilityId = initData.facilityId;
      this.facilityName = initData.facilityName;
      this.submit();
    },
    buildFormData(): FormData {
      const data = new FormData();
      data.append(`report[title]`, this.title);
      data.append(`report[status]`, this.reportStatus);
      data.append(`report[facility_id]`, this.facilityId);
      return data;
    },
    async submit(): Promise<void> {
      this.formStatus = 'pending';
      const formData = this.buildFormData();

      try {
        const res = await this.$http.post(this.submissionUrl, formData);
        this.formStatus = 'success';
        window.Turbolinks.visit(res.data);
      } catch (error) {
        this.formStatus = 'failure';
        const { message, validationErrors } = parseError(error);
      }
    },
  },
  created() {
    this.facilityId = ReportInitialData.facilityId;
    this.title = ReportInitialData.title;
    this.createdDate = ReportInitialData.createdDate;
    this.facilityName = ReportInitialData.facilityName;
    this.reportStatus = ReportInitialData.status;
  },
  mounted() {
    this.hideTopNavs();
  },
  computed: {
    submissionUrl(): string {
      // @ts-ignore
      return `${this.submissionPath}.json`;
    },
  },
};
</script>
