<template>
  <div class="error-alert alert alert--error">
    <div>{{ error }}</div>

    <ul class="errors" v-if="hasMessages">
      <li class="mb-1" v-for="message in messages" :key="message">
        {{ message }}
      </li>
    </ul>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';
import { isEmpty } from 'lodash';

export default Vue.extend({
  name: 'FormErrors',
  props: {
    messages: Array,
    error: String,
  },
  computed: {
    hasMessages(): boolean {
      return !isEmpty(this.messages);
    },
  },
});
</script>

<style lang="scss" scoped>
.error-alert {
  @apply flex flex-col;
}

.errors {
  @apply mt-3 list-disc list-inside;
}
</style>
