import ts from "rollup-plugin-typescript2";
import serve from "rollup-plugin-serve";
import { nodeResolve } from "@rollup/plugin-node-resolve";
import { fileURLToPath } from "url";
import { dirname, resolve } from "path";
import commonjs from "@rollup/plugin-commonjs";
// __dirname __filename
console.log(import.meta.url);
const __filename = fileURLToPath(import.meta.url); // 当前文件的绝对路径

const __dirname = dirname(__filename); // 当前文件所在的文件夹 绝对路径

export default {
  input: resolve(__dirname, "src/index.ts"),
  output: {
    format: "iife",
    file: resolve(__dirname, "dist/bundle.js"),
    sourcemap: true, // 源码调试的功能
  },
  plugins: [
    commonjs(),
    nodeResolve({
      extensions: [".js", ".ts"],
      browser: true, // 当前代码是在浏览器中使用的
    }),
    ts({
      tsconfig: resolve(__dirname, "tsconfig.json"),
    }),
    serve({
      port: 3000,
      openPage: "/assets/index.html",
      //   open: true,
    }),
  ],
};
