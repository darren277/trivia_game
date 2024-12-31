const path = require("path");

module.exports = {
  mode: "production", // Set to "development" for debugging
  entry: {
    app: "./js/app.js",
  },
  output: {
    filename: "[name].js",
    path: path.resolve(__dirname, "../priv/static/js"),
    publicPath: "/js/",
  },
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: ["style-loader", "css-loader"],
      },
      {
        test: /\.(png|jpe?g|gif|svg|eot|ttf|woff|woff2)$/i,
        type: "asset",
      },
    ],
  },
  resolve: {
    extensions: [".js", ".json"],
  },
  devtool: "source-map",
  optimization: {
    minimize: true,
  },
};
