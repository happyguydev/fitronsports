const environment = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009',
      },
      stage: 3,
    }),
    require('autoprefixer'),
    require('tailwindcss'),
  ],
};

// if (process.env.RAILS_ENV !== 'development') {
//   environment.plugins.push(
//     require('@fullhuman/postcss-purgecss')({
//       content: [
//         './app/**/*.html.erb',
//         './app/components/**/*.rb',
//         './app/components/**/*.erb',
//         './app/helpers/**/*.rb',
//       ],
//       defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || [],
//       whitelistPatternsChildren: [/trix/, /attachment/, /button/],
//     })
//   );
// }

module.exports = environment;
