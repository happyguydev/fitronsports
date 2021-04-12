<template>
  <div class="flex flex-col">
    <div class="flex flex-row md:justify-between items-start">
      <h1 class="create-report__title" v-show="wizardStep === 1">
        {{ title }}
      </h1>
      <div
        id="report-detail__edit-title"
        v-show="wizardStep === 1"
        class="hidden md:flex"
      >
      </div>
    </div>
    <div
      class="flex flex-row justify-between items-center py-3 border-b mb-8"
      v-show="wizardStep === 4"
    >
      <h1 class="text-base font-medium">{{ $t('report_part_editor.sign_your_report') }}</h1>
    </div>

    <ReportDetail
      v-show="wizardStep === 1 || wizardStep === 4"
      :facilityName="facilityName"
      :goodPartsCount="getPartsCountByRate('good')"
      :problematicPartsCount="getPartsCountByRate('problematic')"
      :badPartsCount="getPartsCountByRate('bad')"
      :createdDate="reportDate"
    />

    <ReportPartList
      v-if="wizardStep === 1"
      :status="formStatus"
      :submitType="submitType"
      :partsList="partsList"
      :isValidSubmit="valid"
      :isEditableReport="reportStatus==='draft'"
      @clickAddNewPart="onClickAddNewPart"
      @clickSaveAsDraft="onClickSaveAsDraft"
      @clickSignature="onClickSignature"
      @clickEditPart="openEditPart"
    />

    <SignatureForm
      v-if="wizardStep === 4"
      :status="formStatus"
      :submitType="submitType"
      @clickSubmitAfterSign="onClickSubmit"
      @clickCancelSign="onCancelSignature"
    />

    <ReportTitleForm
      v-if="wizardStep === 2"
      :homePath="homePath"
      :propTitle="title"
      :propFacilityName="facilityName"
      :propFacilityId="facilityId"
      :isNotFirstTime="true"
      :isUpdateReport="true"
      @submitTitleAndFacility="onSubmitTitleAndFacility"
    />

    <ReportPartEditor
      v-if="wizardStep === 3"
      :reportPart="activePart"
      :index="activeIndex"
      @close="onCloseEditor"
      @submitReportPart="onSubmitReportPart"
      @deleteReportPart="onDeleteReportPart"
    />

    <CancelReportModal
      :visible="cancelModalVisible"
      :cancelPath="cancelPath"
      @close="cancelModalVisible = false"
      @save-as-draft="onClickSaveAsDraft"
    />

    <UploadProgress :percent="uploadPercentage" v-if="uploading" />
  </div>
</template>

<script lang="ts">
import { isEmpty } from 'lodash';
import {
  IReportPart,
  ReportPart,
  ReportFormSteps,
} from '../interfaces/report_part';
import { parseError } from '../../common/utils/errors';
import { dataURItoBlob } from '../../common/utils/signature';
import { getFormDataSize } from '../../common/mixins/attachments';

import ReportTitleForm from './report_title_form.vue';
import ReportDetail from './report_detail.vue';
import ReportPartList from './report_part_list.vue';
import SignatureForm from './signature_form.vue';
import ReportPartEditor from './report_part_editor.vue';
import CancelReportModal from './cancel_report_modal.vue';
import UploadProgress from '../../common/attachments/upload-progress.vue';

export default {
  name: 'ReportForm',
  components: {
    ReportTitleForm,
    ReportDetail,
    ReportPartList,
    SignatureForm,
    ReportPartEditor,
    CancelReportModal,
    UploadProgress,
  },
  props: {
    submissionPath: String,
    redirectPath: String,
    draftPath: String,
    cancelPath: String,
    homePath: String,
  },
  data: () => ({
    title: '',
    facilityId: '',
    facilityName: '',
    createdDate: '',
    submitType: '',
    reportStatus: 'draft',
    partsList: [] as IReportPart[],
    signatureDataURL: null,
    activePart: {
      title: '',
      description: '',
      rate: '',
      product_id: -1,
      product_title: '',
      attachments: [],
    } as IReportPart,
    activeIndex: 0,
    wizardStep: ReportFormSteps.editTitle,
    cancelModalVisible: false,
    valid: false,
    formStatus: 'idle',
    uploadPercentage: 0,
    uploading: false,
  }),
  methods: {
    openEditor() {
      this.wizardStep = ReportFormSteps.editPart;
      this.hideTopNavs();
    },
    closeEditor() {
      this.wizardStep = ReportFormSteps.partList;
      this.showTopNavs();
    },
    openTitleForm(e: Event) {
      e.preventDefault();
      if (this.reportStatus !== 'draft') {
        return;
      }
      this.wizardStep = ReportFormSteps.editTitle;
      this.hideTopNavs();
    },
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
    showTopNavs() {
      const headerNav = document.querySelector('.dashboard-header');
      if (headerNav) {
        headerNav.classList.remove('hidden-always');
      }
      const dashboardWrapper = document.querySelector('.dashboard-wrapper');
      if (dashboardWrapper) {
        dashboardWrapper.classList.add('dashboard-wrapper--with-toolbar');
        dashboardWrapper.dataset.headerVisible = true;
      }
    },
    onSubmitTitleAndFacility(initData: any) {
      this.title = initData.title;
      this.facilityId = initData.facilityId;
      this.facilityName = initData.facilityName;

      this.wizardStep = ReportFormSteps.partList;
      this.showTopNavs();
    },
    onCloseEditor() {
      this.closeEditor();
    },
    onClickAddNewPart() {
      this.openEditPart(this.partsList.length, new ReportPart());
    },
    openEditPart(selectedIndex: number, selectedPart: IReportPart) {
      this.activeIndex = selectedIndex;
      this.activePart = selectedPart;
      this.openEditor();
    },
    onSubmitReportPart(reportPartIndex: number, reportPartData: IReportPart) {
      if (reportPartIndex !== this.partsList.length) {
        this.partsList[reportPartIndex] = reportPartData;
      } else {
        this.partsList.push(reportPartData);
      }
      this.closeEditor();
    },
    onDeleteReportPart(reportPartIndex: number) {
      if (this.partsList[reportPartIndex].saved) {
        console.log("delete saved report part");
        this.partsList[reportPartIndex].destroyed = true;
      } else {
        console.log("delete unsaved report part");
        this.partsList.splice(reportPartIndex, 1);
      }
      this.closeEditor();
    },
    onClickBack(event: Event) {
      event.preventDefault();
      if (this.reportStatus === 'draft') {
        this.cancelModalVisible = true;
      } else {
        window.Turbolinks.visit(this.homePath);
      }
    },
    onClickSaveAsDraft() {
      this.submitType = 'draft';
      this.submit();
    },
    onClickSignature() {
      this.wizardStep = ReportFormSteps.signature;
      this.hideTopNavs();
    },
    onCancelSignature() {
      this.wizardStep = ReportFormSteps.partList;
      this.showTopNavs();
    },
    onClickSubmit(signDataURL: any) {
      this.onCancelSignature();

      this.submitType = 'sent';
      this.signatureDataURL = signDataURL;
      this.submit();
    },
    loadStaticReportData() {
      const reportPartListElement = document.getElementById('report-data') as HTMLDivElement;
      if (reportPartListElement) {
        reportPartListElement.querySelectorAll('.report-part-item').forEach((element) => {
          const reportPartElement = element as HTMLDivElement;
            const reportPart = {
              ...reportPartElement.dataset,
              saved: true,
              destroyed: false,
              attachments: [],
            };

            reportPartElement
              .querySelectorAll('.report-part__attachment')
              .forEach((attachmentElement, index) => {
                const attachmentData = {
                  id: attachmentElement.dataset.id,
                  fileURL: attachmentElement.dataset.image,
                  note: attachmentElement.dataset.note,
                  file: null,
                  saved: true,
                  destroyed: false,
                };
                reportPart.attachments.push(attachmentData);
              });
            this.partsList.push(reportPart);
          });
      }
    },
    buildFormData(): FormData {
      const data = new FormData();
      this.partsList.forEach((reportPart, index) => {
        if (reportPart.saved === true) {
          data.append(
            `report[report_parts_attributes][${index}][id]`,
            reportPart.id
          );

          if (reportPart.destroyed) {
            data.append(
              `report[report_parts_attributes][${index}][_destroy]`,
              true
            );
          }
        }
        data.append(
          `report[report_parts_attributes][${index}][title]`,
          reportPart.title
        );
        data.append(
          `report[report_parts_attributes][${index}][product_id]`,
          reportPart.product_id
        );
        data.append(
          `report[report_parts_attributes][${index}][description]`,
          reportPart.description
        );
        data.append(
          `report[report_parts_attributes][${index}][rate]`,
          reportPart.rate
        );
        reportPart.attachments.forEach((attachment, attachmentIndex) => {
          if (attachment.destroyed === true) {
            data.append(
              `report_parts[attributes][${index}][images_attachments][${attachmentIndex}][_destroy]`, true
            );
          }
          if (attachment.saved === true) {
            data.append(
              `report_parts[attributes][${index}][images_attachments][${attachmentIndex}][id]`,
              attachment.id
            );
          } else {
            data.append(
              `report_parts[attributes][${index}][images_attachments][${attachmentIndex}][image]`,
              attachment.blobId
            );
          }
          // can update image only while editing saved attachment
          data.append(
            `report_parts[attributes][${index}][images_attachments][${attachmentIndex}][note]`,
            attachment.note
          );
        });
      });
      data.append(`report[title]`, this.title);
      data.append(`report[status]`, this.submitType);
      data.append(`report[facility_id]`, this.facilityId);
      if (this.submitType === 'sent') {
        data.append(
          'report[signature_attributes][image]',
          dataURItoBlob(this.signatureDataURL),
          'signature.png'
        );
      }

      return data;
    },
    async submit(): Promise<void> {
      this.formStatus = 'pending';
      const formData = this.buildFormData();

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
          console.log("upload progress ...", this.uploadPercentage);
          if (this.uploadPercentage >= 90) {
            clearInterval(manualUploader);
          }
        }, sizeOfFormData * 0.7);

        const config = {
          onUploadProgress: (e) =>{
            // stops manual timer, and use the browser supported progress callback here.
            clearInterval(manualUploader);

            this.uploadPercentage = Math.round((e.loaded * 100) / e.total);
            console.log("uploading: ", this.uploadPercentage, e.loaded, e.total);
          },
          onDownloadProgress: (e) => {
            console.log("downloading ...");
            this.uploadPercentage = 100;
            this.uploading = false;
          },
        };

        // show upload progress modal
        console.log("start submit ...");
        this.uploadPercentage = 10;
        this.uploading = true;

        await this.$http.put(this.submissionUrl, formData, config);
        this.formStatus = 'success';
        if (this.redirectPath && this.submitType === 'sent') {
          window.Turbolinks.visit(this.redirectPath);
        } else if (this.draftPath && this.submitType === 'draft') {
          window.location.replace(this.draftPath);
        }
      } catch (error) {
        this.formStatus = 'failure';
        const { message, validationErrors } = parseError(error);
        console.log('error');
      }
    },
    getPartsCountByRate(rate: string): number {
      return this.partsList.filter(
        (part) => part.rate === rate && !part.destroyed
      ).length;
    },
  },
  mounted() {
    // clone edit-title icon
    const editTitleElement = document.querySelector('#report-detail__edit-title');
    const headerTitleElement = document.querySelector('.js-edit-report-title');
    editTitleElement.innerHTML = headerTitleElement.parentElement.innerHTML;

    const backButton = document.querySelector('.js-wizard-back');
    backButton?.addEventListener('click', this.onClickBack);
    document
      .querySelectorAll('.js-edit-report-title')
      .forEach((editTitleButton) => {
        editTitleButton?.addEventListener('click', this.openTitleForm);
      });

    this.$watch(
      () => [this.partsList, this.title, this.facilityId],
      ([partsList, title, facilityId]) => {
        this.valid = !!title && !isEmpty(partsList) && facilityId >= 0;
      },
      {
        immediate: true,
        deep: true,
      }
    );
  },
  computed: {
    submissionUrl(): string {
      // @ts-ignore
      return `${this.submissionPath}.json`;
    },
    reportDate(): string {
      if (this.createdDate !== '') {
        return this.createdDate;
      }
      const today = new Date();
      return today.toLocaleDateString('en-GB');
    },
  },
  created() {
    this.facilityId = ReportInitialData.facilityId;
    this.title = ReportInitialData.title;
    this.createdDate = ReportInitialData.createdDate;
    this.facilityName = ReportInitialData.facilityName;
    this.reportStatus = ReportInitialData.status;

    this.wizardStep = ReportFormSteps.partList;

    this.loadStaticReportData();
  },
  beforeDestroy() {
    const backButton = document.querySelector('.js-wizard-back');
    backButton?.removeEventListener('click', this.onClickBack);
    const editTitleButton = document.querySelector('#js-edit-report-title');
    editTitleButton?.removeEventListener('click', this.openTitleForm);
  },
};
</script>
