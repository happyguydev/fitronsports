<template>
  <div class="wizard-actions" data-after-wizard-hint="true">
    <CancelRequestModal
      :visible="cancelModalVisible"
      :cancelPath="cancelRequestPath"
      @close="cancelModalVisible = false"
      @save-as-draft="$emit('save-as-draft')"
    />
    <button
      @click="cancelModalVisible = true"
      type="button"
      class="button button--outline mr-6"
    >
      {{ $t('actions.cancel') }}
    </button>
    <input
      type="submit"
      class="button button--primary submit"
      :disabled="!valid || status === 'pending'"
      :value="status === 'pending' ? $t('actions.pending') : $t('actions.submit')"
    />
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import CancelRequestModal from './cancel_request_modal.vue';

const RequestFormActions = Vue.extend({
  name: 'RequestFormActions',
  props: {
    valid: Boolean,
    status: String,
    cancelRequestPath: String,
  },
  components: {
    CancelRequestModal,
  },
  data: () => ({
    cancelModalVisible: false,
  }),
  methods: {
    onBackClick(event: Event) {
      event.preventDefault();
      this.cancelModalVisible = true;
    },
  },
  mounted() {
    const backButton = document.querySelector('.js-wizard-back');
    backButton?.addEventListener('click', this.onBackClick);
  },
  beforeDestroy() {
    const backButton = document.querySelector('.js-wizard-back');
    backButton?.removeEventListener('click', this.onBackClick);
  },
});

export default RequestFormActions;
</script>

<style lang="scss" scoped>
  .wizard-actions {
    .button--outline {
      @apply shadow-none;
    }
  }
</style>
