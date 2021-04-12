<template>
  <div class="flex flex-col flex-wrap signature-form">
    <div class="w-full flex flex-col text-base font-medium mt-4 mb-2">
      {{$t('common.e_sign_hint')}}
    </div>
    <div class="w-full flex flex-col">
      <canvas class="signature_pad"></canvas>
    </div>

    <div class="wizard-actions" id="signature-actions">
      <button
        @click="onCancelSignature"
        type="button"
        class="button button--outline mr-3"
        :disabled="status === 'pending'"
      >
        {{ $t('actions.cancel') }}
      </button>
      <button
        @click="onSubmitClick"
        type="button"
        class="button button--primary submit ml-3"
        :disabled="status === 'pending' || !hasSigned"
      >
        {{ submitButtonLabel }}
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import SignaturePad from 'signature_pad';
import { configSignaturePad } from '../../common/utils/signature';

export default {
  name: 'SignatureForm',
  props: {
    status: String,
    submitType: String,
  },
  data: () => ({
    hasSigned: false,
    signaturePad: null,
  }),
  methods: {
    onSubmitClick() {
      const signatureURL = this.signaturePad.toDataURL();
      this.$emit('clickSubmitAfterSign', signatureURL);
    },
    onCancelSignature() {
      this.$emit('clickCancelSign');
    },
    configPad() {
      const signatureCanvas = document.querySelector(
        'canvas'
      ) as HTMLCanvasElement;
      configSignaturePad(
        signatureCanvas,
        this.signaturePad,
        ''
      );
    },
    initSignature() {
      // initialize signature pad
      const signatureCanvas = document.querySelector('canvas');
      this.signaturePad = new SignaturePad(signatureCanvas, {
        minWidth: 1,
        maxWidth: 5,
        minDistance: 2,
        penColor: 'rgb(66,133,244)',
        onEnd: () => {
          this.hasSigned = true;
        },
      });
      window.onresize = window.onload = this.configPad;
      this.configPad();
      // add refresh event listener
      signatureCanvas.addEventListener('click', (e) => {
        const rect = e.target.getBoundingClientRect();
        const posX = rect.right - e.clientX;
        const posY = e.clientY - rect.top;
        if (posX < 40 && posX > 16 && posY < 40 && posY > 16) {
          // reset signature clicked
          this.hasSigned = false;
          this.configPad();
        }
      });
    },
  },
  computed: {
    submitButtonLabel(): string {
      if (this.status === 'pending' && this.submitType === 'sent') {
        return this.$t('actions.submitting');
      }
      return this.$t('actions.submit');
    },
  },
  mounted() {
    this.initSignature();
  },
};
</script>
