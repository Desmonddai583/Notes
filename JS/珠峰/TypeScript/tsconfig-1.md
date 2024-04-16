## Language and Environment （语言和环境 ，语法）

- target：打包后的一个语法支持, 默认会引入对应的 ts 的类型声明文件，可以在 lib 中自己定义所需的声明文件
- lib 手动指定要加载的声明文件
- jsx：为了区分 jsx 是否需要转化 ，以及如何转化 preseve 、 react-jsx
- experimentalDecorators 开启装饰器 可以使用装饰器的写法
- emitDecoratorMetadata 自动生成元数据 design:type ... reflect-metadata 拿到对应的信息
- jsxFactory 区分创建虚拟 dom 所用的方法 h() , React.createElement()
- jsxFragmentFactory 文档碎片采用的是 React.Fragment 还是 Fragment
- jsxImportSource 自动导入模块的时候 解析的路径名
- reactNamespace：指定谁调用的 createElement 方法
- noLib 就是没有任何的 lib 库，和 lib 互相冲突
- useDefineForClassFields 采用 Object.defineProeprty 来定义类中的方法
- moduleDetection: 是否对我们的模块进行强制处理

## modules 模块

- module: commonjs es 模块 AMD Systemjs (打包最终输出的模块化规范)
- rootDir 当前项目的根目录
- moduleResolution classic 不建议用（import 'a' 会找文件不找文件夹） nodeNext 给 node 来用的，在引入的时候 必须写后缀 bundler 主要是给我们的 es6 语法来提供的
- baseUrl 指定解析文件路径
- paths 做文件别名处理的
- rootDirs 指定文件项目中哪些目录是共享的，可以用于合并声明文件
- typeRoots 查找声明文件的存放路径 ， 可以通过 types 字段指定哪些要加载
- allowUmdGlobalAccess 可以直接在模块中访问 umd 模块
- allowImportingTsExtensions 是否运行 ts 扩展名

## js 支持

- allowJs 在 ts 中可以使用 js 文件
- checkJs 允许检测 js
- maxNodeModuleJsDepth node_modules 查找的层级

## 发射文件

- declaration 是否生成.d.ts
- declarationMap 根据.d.ts 生产 map 文件
- emitDeclarationOnly 只生成声明文件
- sourceMap 给源代码生产 sourcemap
- inlineSourceMap 文件内部 sourcemap
- outFile 给 amd systemjs 生产一个文件，最终打包到一起
- outDir 指定最终输出的目录
- removeComments 移除注释
- noEmit 不做文件发射
- importHelpers （tslib） 将辅助方法 移入到 tslib 中
- importsNotUsedAsValues 没有用到的东西做为值来使用会被移除
- downlevelIteration 是否对 iterator 来降级
- sourceRoot mapRoot 只要是给 debugger 来用的 告诉他我们原文件目录 和 map 目录的位置
- inlineSources 主要就是解决源文件被压缩的问题
- emitBOM 给文件生产 bom 头
- newLine 换行符 crlf windows lf linux
- stripInternal 标识为 internal 不会生成声明文件
- noEmitHelpers 不生成 helpers
- noEmitOnError 有错误是否要继续生产
- preserveConstEnums 将常量枚举 转化成对象
- declarationDir 声明文件输出的出口
- preserveValueImports 过时了

- Interop Constraints

- isolatedModules 严格模块导出， 如果类型需要增加 type 标识
- verbatimModuleSyntax 可以替代 isolatedModules ， importsNotUsedAsValues ， preserveValueImports
- preserveSymlinks webpack 中有一个 symlink nodejs 中的符号链接
- forceConsistentCasingInFileNames 强制区分文件名字的大小写
