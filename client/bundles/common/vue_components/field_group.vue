<template>
  <div class="field-group">
    <div class="field-group__title">{{ title }}</div>
    <slot></slot>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'FieldGroup',
  props: {
    title: {
      type: String,
      required: true,
    },
  },
});
</script>
