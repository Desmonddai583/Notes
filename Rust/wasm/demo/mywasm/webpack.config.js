const path = require('path');
module.exports = {
  entry: "./test.js",
  output: {
    path: path.resolve(__dirname, "dist"),
    filename: "test.js",
  },
  mode: "development",
  devServer: {
    static: path.join(__dirname, "dist")
  },
  experiments: {
    asyncWebAssembly: true,
  }
};