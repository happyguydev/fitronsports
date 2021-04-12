/* eslint-disable @typescript-eslint/no-var-requires */
const { environment } = require('@rails/webpacker');
const { VueLoaderPlugin } = require('vue-loader');
const cloneDeep = require('lodash/cloneDeep');
const vue = require('./loaders/vue');
const typescript = require('./loaders/typescript');
const customConfig = require('./custom');

environment.loaders.prepend('typescript', typescript);
environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin());
environment.loaders.prepend('vue', vue);
environment.config.merge(customConfig);

const sassLoader = environment.loaders.get('sass');

const sassUse = sassLoader.use;
delete sassLoader.use;

sassLoader.oneOf = [
  {
    resourceQuery: /module/,
    use: sassUse
      .map((use) => {
        if (use.loader === 'css-loader') {
          return {
            ...cloneDeep(use),
            options: {
              ...use.options,
              ...{
                modules: {
                  localIdentName: '[hash:base64:5]',
                },
              },
            },
          };
        }
        return cloneDeep(use);
      })
      .reduce((x, y) => x.concat(y), []),
  },
  { resourceQuery: /scoped/, use: sassUse },
  { use: sassUse },
];

module.exports = environment;
