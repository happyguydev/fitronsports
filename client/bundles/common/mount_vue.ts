import Vue, { Component } from 'vue';
import { parseAppData } from './parse_app_data';
import './vue_components';

/**
 * Mounts a VueJS component in a specific element on Turbolinks:Load
 *
 * @param {import('vue').Component} component - The Vue component to be mounted
 * @param {string} elementSelector - The selector for the element
 */
const mountVue = (
  component: Component,
  elementSelector: string,
  dataAttributeProps: string[] = [],
  i18nComponent: any,
) => {
  document.addEventListener('turbolinks:load', () => {
    const element = document.querySelector(elementSelector) as HTMLDivElement;
    if (!element) {
      console.warn(
        `[Vue] tried to mount without an element (selector: ${elementSelector})`
      );
      return null;
    }

    const props = dataAttributeProps
      .map((attribute) => {
        const value = element.dataset[attribute];
        console.log(attribute, value);
        return {
          key: attribute,
          value,
        };
      })
      .reduce((initial, current) => {
        return {
          ...initial,
          [current.key]: current.value,
        };
      }, {});

    const { props: appProps } = parseAppData();
    const app = new Vue({
      el: element,
      render: (h) =>
        h(component, {
          props: {
            ...props,
            ...appProps,
          },
        }),
      i18n: i18nComponent,
    });
    app.$mount();

    return app;
  });
};

export { mountVue };
