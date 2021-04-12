<template>
  <div class="flex flex-col">
    <h1 class="report-list__facility">{{ facilityName }}</h1>

    <div class="flex flex-row mt-4 md:mt-2">
      <div class="flex flex-row justify-between md:justify-start w-full">
        <div class="report-flag w-full md:w-auto">
          <div class="report-flag__icon">
            <clock-edit-icon />
          </div>
          <div class="report-flag__body">
            <div class="report-flag__title">
              {{ $t('common.time') }}
            </div>
            <div class="report-flag__detail">
              {{ createdDate }}
            </div>
          </div>
        </div>

        <div class="report-flag w-full md:w-auto md:ml-10">
          <div class="report-flag__icon">
            <status-flag-icon />
          </div>
          <div class="report-flag__body">
            <div class="report-flag__title">
              {{ $t('common.status') }}
            </div>
            <div class="report-flag__detail">
              {{ $t('common.draft') }}
            </div>
          </div>
        </div>
      </div>
      <div class="hidden md:flex flex-1" id="report-detail__delete"></div>
    </div>

    <div class="flex flex-row mt-4">
      <div class="report-flag w-full md:w-auto">
        <div class="report-flag__icon">
          <building-icon />
        </div>
        <div class="report-flag__body">
          <div class="report-flag__title">
            {{ $t('common.by') }}
          </div>
          <div class="report-flag__detail">
            Fitron Sport
          </div>
        </div>
      </div>
    </div>

    <div class="flex flex-row flex-wrap mt-2 border-b pb-6">
      <span class="report-list__item--rate good">
        {{$t('report_part_rate.good')}} (<span class="report-item__rate-count"> {{goodPartsCount}} </span>)
      </span>
      <span class="report-list__item--rate problematic">
        {{$t('report_part_rate.problematic')}} (<span class="report-item__rate-count">{{ problematicPartsCount }}</span>)
      </span>
      <span class="report-list__item--rate bad">
        {{$t('report_part_rate.bad')}} (<span class="report-item__rate-count">{{ badPartsCount }}</span>)
      </span>
    </div>
  </div>
</template>

<script lang="ts">
export default {
  name: 'ReportDetail',
  props: {
    facilityName: String,
    goodPartsCount: Number,
    problematicPartsCount: Number,
    badPartsCount: Number,
    createdDate: String,
  },
  mounted() {
    const deleteElement = document.querySelector('#report-detail__delete');
    const headerDeleteElement = document.querySelector('.js-delete-report');
    deleteElement.innerHTML = headerDeleteElement.parentElement.innerHTML;

  }
};
</script>
