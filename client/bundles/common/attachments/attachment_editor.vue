<template>
  <modal @close="closeEditor">
    <div class="flex flex-row justify-start items-center w-full">
      <div class="tools flex flex-row w-full flex-wrap">
        <EditorTool
          type="arrow"
          iconClass="fas fa-long-arrow-alt-down fa-lg"
          :selectedTool="selectedMode"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="circle"
          iconClass="far fa-circle fa-lg"
          :selectedTool="selectedMode"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="rect"
          iconClass="far fa-square fa-lg"
          :selectedTool="selectedMode"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="freeDrawing"
          iconClass="fas fa-pencil-alt fa-lg"
          :selectedTool="selectedMode"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="text"
          iconClass="fas fa-font fa-lg"
          :selectedTool="selectedMode"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="crop"
          iconClass="fa-crop-alt fas fa-lg"
          :selectedTool="selectedMode"
          v-show="selectedMode !== 'crop'"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="crop"
          iconClass="fa-check-circle fas fa-lg"
          :selectedTool="selectedMode"
          v-show="selectedMode === 'crop'"
          @toolChanged="toolChanged"
        />
        <EditorTool
          type="eraser"
          iconClass="fas fa-eraser fa-lg"
          :selectedTool="selectedMode"
          @toolChanged="toolChanged"
        />
      </div>
    </div>
    <div class="flex flex-row">
      <div class="flex flex-col">
        <Editor
          :canvasWidth="attachmentWidth"
          :canvasHeight="attachmentHeight"
          ref="editor"
          editorId="1"
        />
        <div class="flex flex-row justify-between mt-2">
          <button
          @click="closeEditor"
          class="btn bg-transparent border border-primary-500 rounded text-sm px-2 py-1 mr-3 flex-1"
          >
            {{$t('actions.cancel')}}
          </button>
          <button
            @click="applyEditor"
            class="btn bg-primary-500 rounded text-sm px-2 py-1 flex-1 ml-3"
          >
            {{$t('actions.save')}}
          </button>
        </div>
      </div>
      <div class="colors flex flex-col flex-1 items-end">
        <ColorPicker
          color="black"
          :selectedColor="selectedColor"
          @colorChanged="colorChanged"
        />
        <ColorPicker
          color="red"
          :selectedColor="selectedColor"
          @colorChanged="colorChanged"
        />
        <ColorPicker
          color="green"
          :selectedColor="selectedColor"
          @colorChanged="colorChanged"
        />
        <ColorPicker
          color="yellow"
          :selectedColor="selectedColor"
          @colorChanged="colorChanged"
        />
        <ColorPicker
          color="blue"
          :selectedColor="selectedColor"
          @colorChanged="colorChanged"
        />
      </div>
    </div>
  </modal>
</template>

<script lang="ts">
import Vue from 'vue';
import Editor from 'vue-image-markup';
import ColorPicker from './editor/color_picker.vue';
import EditorTool from './editor/editor_tool.vue';
import '@fortawesome/fontawesome-free/css/all.css';

export default Vue.extend({
  name: 'AttachmentEditor',
  components: {
    Editor,
    ColorPicker,
    EditorTool,
  },
  data: () => ({
    selectedColor: 'red',
    selectedMode: 'freeDrawing',
    previousMode: '',
  }),
  props: {
    attachmentUrl: String,
    attachmentWidth: Number,
    attachmentHeight: Number,
  },
  methods: {
    colorChanged(color: string) {
      this.selectedColor = color;
      this.updateEditorSetting();
    },
    toolChanged(tool: string) {
      this.previousMode = this.selectedMode;
      this.selectedMode = tool;
      this.updateEditorSetting();
    },
    updateEditorSetting() {
      if (this.selectedMode === 'text') {
        this.$refs.editor.set(this.selectedMode, { fill: this.selectedColor });
      } else if (this.selectedMode === 'crop') {
        if (this.previousMode !== 'crop') {
          this.$refs.editor.set(this.selectedMode);
        } else {
          console.log("apply crop ...");
          this.$refs.editor.applyCropping();
          this.selectedMode = '';
        }
      } else {
        this.$refs.editor.set(this.selectedMode, { stroke: this.selectedColor });
      }
    },
    closeEditor(e) {
      if (e) {
        e.preventDefault();
      }
      if (confirm(this.$t('image_editor.quit_alert'))) {
        this.$emit('close');
      }
    },
    applyEditor(e) {
      e.preventDefault();
      this.$emit('applyEdit', this.$refs.editor.saveImage());
    },
  },
  mounted() {
    this.$refs.editor.setBackgroundImage(this.attachmentUrl);
    this.updateEditorSetting();
  },
});
</script>
