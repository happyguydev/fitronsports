<template>
  <div class="wizard-bottom-hint" data-with-actions="true">
    <p class="text-center text-grey-500 text-xs">
      {{ $t('common.mandatory_field_hint') }}
    </p>
  </div>
</template>

<script lang="ts">
import Vue from 'vue';

export default Vue.extend({
  name: 'MandatoryHint',
});
</script>
