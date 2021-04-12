import Vue from 'vue';
import { pascalCase } from '../utils/pascal-case';

const req = require.context('.', true, /.vue$/);

req.keys().forEach((key) => {
  const { default: Component } = req(key);
  const componentName = pascalCase(key.substring(2).replace(/.vue$/, ''));
  // console.log(`[Vue] registered component: ${componentName}`);
  Vue.component(componentName, Component);
});
