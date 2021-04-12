<template>
  <div
    class="image-editor-tool"
    :class="{ active: selectedTool===type }"
    @click="$emit('toolChanged', type)"
  >
    <i :class="iconClass" />
  </div>
</template>

<script lang="ts">
export default {
  name: 'EditorTool',
  props: {
    selectedTool: {
      type: String,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
    iconClass: {
      type: String,
      required: true,
    },
  },
};
</script>
