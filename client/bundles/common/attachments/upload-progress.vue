<template>
  <modal :title="$t('common.uploading')" @close="close" :showClose="false">
    <div class="shadow bg-grey-light mt-2 w-48">
      <div
        class="text-xs leading-none py-1 text-center text-white bg-primary-500"
        :style="{width: percent + '%'}">
        {{ progressLabel }}
      </div>
    </div>
  </modal>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'UploadProgress',
  props: {
    percent: Number,
  },
  methods: {
    close() {
    },
  },
  computed: {
    progressLabel() {
      if (this.percent > 10) {
        return `${this.percent}%`;
      }
      return '-';
    },
  },
});
</script>
