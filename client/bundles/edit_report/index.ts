import Vue from 'vue';
import VueI18n from 'vue-i18n';
import VueTurbolinks from 'vue-turbolinks';
import VueAxios from 'vue-axios';
import axios from 'axios';

import { mountVue } from '../common/mount_vue';
import EditReportForm from './components/edit_report_form.vue';
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

export function initEditReportForm() {
  initAxios();
  mountVue(
    EditReportForm,
    '.js-report-edit-form',
    ['submissionPath', 'redirectPath', 'draftPath', 'cancelPath', 'homePath'],
    I18nTranslation
  );
}
