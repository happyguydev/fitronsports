import Vue from 'vue';
import VueAxios from 'vue-axios';
import axios from 'axios';
import VueTurbolinks from 'vue-turbolinks';

export function useVueAxios() {
  Vue.use(VueAxios, axios);
  Vue.use(VueTurbolinks);

  document.addEventListener('turbolinks:load', () => {
    axios.defaults.headers.common['X-CSRF-Token'] = document
      .querySelector('meta[name="csrf-token"]')
      ?.getAttribute('content');
  });
}
