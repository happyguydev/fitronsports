<template>
  <modal @close="$emit('close')">
    <img :src="attachmentUrl" :alt="attachmentUrl" />
  </modal>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'AttachmentView',
  props: {
    attachmentUrl: String,
  },
});
</script>

<style lang="scss" scoped>
img {
  max-height: 90vh;
}
</style>
