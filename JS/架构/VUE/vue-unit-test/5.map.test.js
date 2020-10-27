import {map} from './src/4.map';

// mock fn
// 测试 前端代码里可能有一些ajax 请求 在测试的时候 更改接口的表现
it('测试map方法',()=>{
    let fn = jest.fn(); // 这是jest帮我们提供的一个假的函数
    map([1,2,3],fn);
    expect(fn.mock.calls.length).toBe(3);
    expect(fn.mock.calls[0][0]).toBe(1);
    expect(fn.mock.calls[1][0]).toBe(2);
    expect(fn.mock.calls[2][0]).toBe(3);
 
})

// calls 就是如果这个函数被调用了 
// {"calls": [[1, 0], [2, 1], [3, 2]], "instances": [undefined, undef
//     ined, undefined], "invocationCallOrder": [1, 2, 3], "results": [{"type": "return
//     ", "value": undefined}, {"type": "return", "value": undefined}, {"type": "return
//     ", "value": undefined}]}