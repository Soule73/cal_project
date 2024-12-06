const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
    mode: "development",
    entry: "./src/js/index.js",
    module: {
        rules: [
            {
                test: /\.m?js$/,
                exclude: /node_modules/,
                use: {
                    loader: "babel-loader",
                    options: {
                        presets: ["@babel/preset-env"],
                        plugins: [
                            [
                                "prismjs",
                                {
                                    languages: ["javascript", "css", "markup"],
                                    plugins: ["copy-to-clipboard"],
                                    css: true,
                                },
                            ],
                        ],
                    },
                },
            },
            {
                test: /\.css$/i,
                use: [
                    MiniCssExtractPlugin.loader,
                    "css-loader",
                    {
                        loader: "postcss-loader",
                        options: {
                            postcssOptions: {
                                plugins: [
                                    require("autoprefixer")({
                                        overrideBrowserslist: ["last 2 versions"],
                                    }),
                                    require("tailwindcss")("./tailwind.config.js"),
                                ],
                            },
                        },
                    },
                ],
            },
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/i,
                type: "asset/resource",
            },
        ],
    },
    plugins: [
        new MiniCssExtractPlugin({
            filename: "style.css",
            chunkFilename: "style.css",
        }),
    ],
    output: {
        filename: "bundle.js",
        path: path.resolve(__dirname, "build"),
        clean: true,
        assetModuleFilename: "[path][name][ext]",
    },
    target: "web", // Fix pour le message d'erreur "browserslist"
    stats: "errors-only", // Supprime les messages de log inutiles
    watchOptions: {
        ignored: /node_modules/, // Ignore les modifications dans node_modules
        aggregateTimeout: 300, // Délai avant recompilation après modification
        poll: 1000, // Fréquence de vérification des modifications (en ms)
    },
};
