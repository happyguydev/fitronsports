process.env.NODE_ENV = process.env.NODE_ENV || 'development';

const chokidar = require('chokidar');
const environment = require('./environment');

// environment.config.devServer.before = (app, server) => {
//   chokidar
//     .watch([
//       'config/locales/*.yml',
//       'app/views/**/*.html.erb',
//       'app/views/**/*.html.slim',
//     ])
//     .on('change', () => server.sockWrite(server.sockets, 'content-changed'));
// };

module.exports = environment.toWebpackConfig();
