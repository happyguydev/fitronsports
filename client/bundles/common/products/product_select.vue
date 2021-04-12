<template>
  <v-select
    :class="['field', $style.select]"
    :placeholder="$t('placeholders.search_products')"
    @search="fetchProductOptions"
    :options="products"
    :value="selected"
    label="title"
    @input="handleInput"
  >
    <template v-slot:option="option">
      <div :class="$style.option">
        <span :class="$style.option__title">{{ option.title }}</span>
      </div>
    </template>
    <template v-slot:no-options>
      <span>{{$t('report_part_editor.no_searching_options')}}</span>
    </template>
  </v-select>
</template>

<script lang="ts">
import Vue from 'vue';
// @ts-ignore
import VSelect from 'vue-select';
import 'vue-select/dist/vue-select.css';
import { Product } from '../interfaces/product';

VSelect.props.components.default = () => ({
  Deselect: null,
  OpenIndicator: null,
});

export default Vue.extend({
  name: 'ProductSelect',
  props: {
    label: String,
    selected: String,
  },
  data: () => ({
    products: [] as Product[],
  }),
  components: {
    VSelect,
  },
  methods: {
    async fetchProductOptions(search?: string) {
      const { data } = await this.$http.get('/products.json', {
        params: { search },
      });

      this.products = data;
    },
    handleInput(product: Product) {
      this.$emit('input', product);
    },
  },
  mounted() {
    this.fetchProductOptions();
  },
});
</script>

<style lang="scss" module>
.select {
  @apply rounded-lg border-0 bg-white flex flex-row;
  @apply mb-6 flex flex-row items-center;
  @apply w-full;

  padding: 0.875rem 0.75rem;
  box-shadow: 0px 15px 55px rgba(157, 163, 180, 0.2);
}

.option {
  @apply flex flex-row justify-start;
  @apply items-center py-4;
}

:global {
  .vs__dropdown-toggle,
  .vs__dropdown-menu {
    @apply w-full;
    @apply border-0;
  }

  .vs__dropdown-menu {
    @apply shadow-none;
  }

  .vs__dropdown-option--highlight {
    @apply bg-primary-500;
  }
}
</style>
