import {timer} from './src/6.timer';
jest.useFakeTimers(); // 使用模拟的时间

it('测试五秒后 能否返回调用',()=>{
    let fn = jest.fn();
    timer(fn);
    // jest.runAllTimers(); // 默认立即执行, 如果人家写了一个setInterval
    // jest.advanceTimersByTime(12000) // 前进时间
    jest.runOnlyPendingTimers() // 只运行第一次的
    expect(fn.mock.calls.length).toBe(1);
});

// vue/test-utils