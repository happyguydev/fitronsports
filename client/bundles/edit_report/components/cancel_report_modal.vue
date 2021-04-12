<template>
  <modal
    :title="$t('cancel_modal_report.page_title')"
    :description="$t('cancel_modal_report.description')"
    modal-class="cancel-request-modal"
    @close="$emit('close')"
    @save-as-draft="$emit('save-as-draft')"
    v-show="visible"
  >
    <button
      class="button button--outline mt-3"
      type="button"
      @click="submitDraft"
    >
      <svg
        width="16"
        height="21"
        viewBox="0 0 16 21"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="mr-3"
      >
        <path
          d="M1.4 3C1.4 1.8402 2.3402 0.9 3.5 0.9H12.5C13.6598 0.9 14.6 1.8402 14.6 3V18.5482C14.6 19.0728 13.9741 19.3448 13.5906 18.9868L8.95525 14.6605C8.41735 14.1584 7.58264 14.1584 7.04475 14.6605L2.40939 18.9868C2.02586 19.3448 1.4 19.0728 1.4 18.5482V3Z"
          stroke="#232527"
          stroke-width="1.8"
        />
      </svg>
      {{ $t('cancel_modal_report.save_draft') }}
    </button>
    <a
      class="button button--outline mt-5 delete-request mb-8 t"
      type="button"
      @click="deleteRequest"
    >
      <svg
        width="18"
        height="20"
        viewBox="0 0 18 20"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
        class="mr-3"
      >
        <path
          d="M11 8L10.7 15M7.3 15L7 8M3 4L3.87554 17.133C3.94558 18.1836 4.81818 19 5.87111 19H12.1289C13.1818 19 14.0544 18.1836 14.1245 17.133L15 4M3 4H6M3 4H1M15 4H17M15 4H12M12 4V3C12 1.89543 11.1046 1 10 1H8C6.89543 1 6 1.89543 6 3V4M12 4H6"
          stroke="#FA4A23"
          stroke-width="1.8"
          stroke-linecap="round"
          stroke-linejoin="round"
        />
      </svg>

      {{ $t('cancel_modal_report.delete_request') }}
    </a>
  </modal>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'CancelRequestModal',
  props: {
    cancelPath: {
      type: String,
      required: true,
    },
    visible: {
      type: Boolean,
      default: false,
    },
  },
  methods: {
    deleteRequest() {
      window.location.replace(this.cancelPath);
    },
    submitDraft() {
      this.$emit('close');
      this.$emit('save-as-draft');
    },
  },
});
</script>

<style lang="scss">
.cancel-request-modal {
  @apply max-w-md shadow-md my-auto w-full mx-4;
  border-radius: 6px;
}

.delete-request {
  color: #fa4a23;
  cursor: pointer;
}
</style>
