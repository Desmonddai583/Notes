module.exports = {
  "plugins": {
    // 主要功有是解决@import引入路径问题。
    "postcss-import": {},
    // 相关配置可以点击这里。该插件主要用来处理文件，比如图片文件、字体文件等引用路径的处理
    "postcss-url": {},
    // 用来自动处理浏览器前缀的一个插件
    // "autoprefixer": {}
    "postcss-aspect-ratio-mini": {},
    "postcss-write-svg": { utf8: false },
    //由于cssnext和cssnano都具有autoprefixer,事实上只需要一个，所以把默认的autoprefixer删除掉
    "postcss-cssnext": {},
    "postcss-px-to-viewport": {
      // 视口宽度，对应的是我们设计稿的宽度，一般是750
      viewportWidth: 750,
      // 视口高度，根据750设备的宽度来指定，一般指定1334，也可以不配置
      viewportHeight: 1334,
      // 指定`px`转换为视窗单位值的小数位数
      unitPrecision: 2,
      // 指定需要转换成的视窗单位，建议使用vw
      viewportUnit: 'vw',
      // 指定不转换为视窗单位的类，可以自定义，可以无限添加,建议定义一至两个通用的类名
      selectorBlackList: [],
      // 小于或等于`1px`不转换为视口单位，你也可以设置为你想要的值
      minPixelValue: 1,
      // 允许在媒体查询中转换`px`
      mediaQuery: false,
    },
    "cssnano": {
      "cssnano-preset-advanced": {
        zindex: false,
        autoprefixer: false
      },
    }
  }
}

