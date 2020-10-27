import {removeNode} from './src/2.dom';


// jest 具备jsdom 功能 jsdom环境 可以有dom的概念
it('测试能否正常删除dom节点',()=>{
    document.body.innerHTML = `<div><button id="btn"></button></div>`;
    let btn = document.querySelector('#btn');
    expect(btn).not.toBeNull(); // 刚开始btn 是否存在
    removeNode(btn);
    btn = document.querySelector('#btn');
    expect(btn).toBeNull(); // btn是否被删除掉了
});

// 测试选项卡 开关。。。。

// f 强制刷新没通过的用例
// o 表示根据git历史 来判断运行哪个测试
// 一般都配合git历史
// enter 默认全部重新执行以下