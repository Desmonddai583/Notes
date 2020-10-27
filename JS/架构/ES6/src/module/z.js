// z文件 需要整合 x文件和y文件 这个文件作为统一的入口

// import { x } from './x';
// import { y } from './y';


// export {
//     x,
//     y
// }

// 导入立刻导出

export * from './x';
export {
    y
}
from './y'; // 在文件中导出部分内容
// console.log(y); // 没有使用import  才会有声明的效果