module.exports = {
  test: /\.tsx?(\.erb)?$/,
  use: [
    {
      loader: 'babel-loader',
    },
  ],
};
