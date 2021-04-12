<template>
  <div
    class="color-picker"
    :class="{active: color===selectedColor}"
    @click="$emit('colorChanged', color)"
    :style="{ backgroundColor: color }"
  >
    &nbsp;
  </div>
</template>

<script lang="ts">
export default {
  name: 'ColorPicker',
  props: {
    color: {
      type: String,
      required: true,
    },
    selectedColor: {
      type: String,
      default: '',
    },
  },
};
</script>

<style lang="scss" scoped>
.color-picker {
  @apply m-1 border-none;
  border-radius: 50%;
  width: 2rem;
  height: 2rem;

  &.active{
    @apply border-solid;
    border-width: 4px;
    border-color: gray;
  }
}
</style>
