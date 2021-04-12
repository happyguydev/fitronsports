import Vue from 'vue';
import VueI18n from 'vue-i18n';
import VueTurbolinks from 'vue-turbolinks';
import VueAxios from 'vue-axios';
import axios from 'axios';

import { mountVue } from '../common/mount_vue';
import ServiceRequestForm from './components/service_request_form.vue';
import OrderRequestForm from './components/order_request_form.vue';
import translation from '../common/translations';

Vue.use(VueTurbolinks);
Vue.use(VueAxios, axios);
Vue.use(VueI18n);

const I18nTranslation = new VueI18n({
  locale: I18nLocale,
  messages: translation,
  silentFallbackWarn: true,
});

export function initAxios() {
  document.addEventListener('turbolinks:load', () => {
    axios.defaults.headers.common['X-CSRF-Token'] = document
      .querySelector('meta[name="csrf-token"]')
      ?.getAttribute('content');
  });
}

export function initEquipmentServiceForm() {
  initAxios();
  mountVue(OrderRequestForm, '.js-order-request-form', [
    'redirectPath',
    'draftRedirectPath',
    'submissionPath',
    'cancelPath',
  ],
  I18nTranslation
  );
}

export function initServiceRequestForm() {
  initAxios();
  mountVue(ServiceRequestForm, '.js-service-request-form', [
    'redirectPath',
    'draftRedirectPath',
    'submissionPath',
    'cancelPath',
  ],
  I18nTranslation
  );
}
