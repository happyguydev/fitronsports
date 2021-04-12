<template>
  <div class="attachment" v-show="attachment.destroyed !== true">
    <div class="attachment__header">
      <div class="attachment__overlay">
        <Spinner v-show="uploading" />
        <button
          type="button"
          class="attachment__button"
          v-show="!uploading"
          @click="$emit('edit', index, attachment, width, height)"
        >
          <edit-icon />
        </button>
        <div class="flex flex-col justify-between">
          <button
            type="button"
            class="attachment__button"
            v-show="!uploading"
            @click="$emit('remove', index)"
          >
            <remove-icon />
          </button>

          <button
            type="button"
            class="attachment__button"
            v-show="!uploading"
            @click="$emit('detail', preview)"
          >
            <magnifier-icon />
          </button>
        </div>
      </div>
      <div
        class="attachment__image"
        :class="{ 'attachment__image--uploading': uploading }"
      >
        <img :src="preview" :alt="alt" ref="img" />
      </div>
    </div>

    <div class="attachment__body">
      <field-wrapper>
        <input
          type="text"
          :placeholder="$t('placeholders.attachment_note')"
          :value="attachment.note"
          :disabled="uploading"
          @change="onNoteChange"
        />
      </field-wrapper>
    </div>
  </div>
</template>

<script lang="ts">
import Vue, { PropOptions } from 'vue';
import Spinner from 'vue-simple-spinner';
import { Attachment } from './interfaces/attachment';
import EditIcon from './edit_icon.vue';
import RemoveIcon from './remove_icon.vue';
import FieldWrapper from '../vue_components/field_wrapper.vue';

export default Vue.extend({
  name: 'Attachment',
  props: {
    attachment: {
      type: Object,
      required: true,
    } as PropOptions<Attachment>,
    index: Number,
    uploading: {
      type: Boolean,
      default: false,
    },
  },
  components: {
    EditIcon,
    RemoveIcon,
    FieldWrapper,
    Spinner,
  },
  data: () => ({
    width: 0,
    height: 0,
  }),
  computed: {
    preview(): string {
      if (this.attachment.fileURL !== '') {
        return this.attachment.fileURL;
      }
      return URL.createObjectURL(this.attachment.file);
    },
    alt(): string {
      if (this.attachment.fileURL !== '') {
        return this.attachment.fileURL;
      }
      return this.attachment.file.name;
    },
  },
  methods: {
    onNoteChange(event: Event) {
      const input = event.currentTarget as HTMLInputElement;
      const note = input.value;
      this.$emit('updated', this.index, {
        ...this.attachment,
        note,
      });
    },
  },
  beforeDestroy() {
    if (this.attachment.file) {
      console.log("revokeObjectURL");
      URL.revokeObjectURL(this.preview);
    }
  },
  mounted() {
    const img = this.$refs.img as HTMLImageElement;
    img.onload = () => {
      this.width = img.naturalWidth;
      this.height = img.naturalHeight;
      console.log("attachment dimension:", this.width, this.height);
    };
  },
});
</script>

<style lang="scss" scoped>
.attachment {
  @apply flex flex-col mb-2;
}

.attachment__header {
  @apply relative;
}

.attachment__overlay {
  @apply absolute inset-0;
  @apply flex flex-row justify-between;
  padding: 8px;
}

.attachment__image {
  @apply w-full;
  &--uploading {
    opacity: 0.2;
  }
}

.attachment__image img {
  @apply w-full;
  border-radius: 6px;
  object-fit: cover;
}

.attachment__body {
  @apply mt-2;
}

.attachment__button {
  @apply flex items-center justify-center;
  width: 32px;
  height: 32px;
  background: rgba(0, 0, 0, 0.15);
  border-radius: 6px;
}
</style>
