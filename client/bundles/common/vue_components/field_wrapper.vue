<template>
  <div :class="$style.container">
    <label :class="$style.label" v-if="label">{{ label }}</label>
    <div :class="['field', label && $style.fieldWithLabel]">
      <div class="field__wrapper">
        <slot></slot>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'FieldWrapper',
  props: {
    label: String,
  },
});
</script>

<style lang="scss" module>
.container {
  @apply flex flex-col;
}

.label {
  font-size: 16px;
  line-height: 19px;
  color: #a7a7a7;
}

.fieldWithLabel {
  margin-top: 16px;
}

.description {
  min-height: 144px;
}

textarea {
  // min-height: 144px;
  @apply outline-none w-full h-full;

  &:focus {
    @apply outline-none;
  }

  &::placeholder {
    color: rgba(128, 128, 128, 0.6);
  }
}
</style>
