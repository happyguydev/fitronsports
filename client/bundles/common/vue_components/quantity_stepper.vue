<template>
  <div class="quantity-stepper">
    <label class="quantity-stepper__label" :for="name" v-if="label">
      {{ label }}
    </label>
    <div :class="['stepper field', label && 'stepper--label']">
      <button
        class="stepper__action stepper__action--minus"
        type="button"
        @click="onSubtract"
      >
        -
      </button>
      <input
        type="number"
        :name="name"
        :value="value"
        :disabled="true"
        class="stepper__input"
      />
      <button
        class="stepper__action stepper__action--plus"
        type="button"
        @click="onAdd"
      >
        +
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'QuantityStepper',
  props: {
    label: String,
    name: String,
    value: Number,
    min: {
      type: Number,
      default: 0,
      required: false,
    },
    max: {
      type: Number,
      required: false,
    },
  },
  methods: {
    onAdd() {
      this.$emit(
        'input',
        this.max ? Math.min(this.value + 1, this.max) : this.value + 1
      );
    },
    onSubtract() {
      this.$emit('input', Math.max(this.value - 1, this.min));
    },
  },
});
</script>

<style lang="scss" scoped>
.quantity-stepper {
  &__label {
    font-size: 16px;
    line-height: 19px;
    color: #a7a7a7;
  }
}

.stepper {
  @apply self-start justify-between px-0;
  width: 148px;

  &--label {
    margin-top: 16px;
  }

  &__input {
    @apply appearance-none bg-transparent;
    @apply text-center font-bold ml-1 pl-1 flex-none;
    width: 70px;
    -moz-appearance: textfield;
  }

  &__action {
    @apply h-full flex-1 w-full items-center flex justify-center;
    &--minus {
      @apply border-r;
    }
    &--plus {
      @apply border-l;
    }
  }
}
</style>
