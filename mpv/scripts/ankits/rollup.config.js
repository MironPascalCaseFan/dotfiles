import resolve from "@rollup/plugin-node-resolve";
import commonjs from "@rollup/plugin-commonjs";

export default {
  input: "out/js/main.js",   // your entry file
  output: {
    file: "out/bundled.js",
    format: "cjs"  // mpv likes CommonJS-style
  },
  plugins: [
    resolve({
      modulePaths: "./src/"
    }),
    commonjs(),
  ]
};
