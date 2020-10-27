jest.mock('./src/5.ajax.js') ; // 这个文件用假的 找同名的文件夹 去替换
import {fetchUser,fetchList} from './src/5.ajax';

let {sum} = jest.requireActual('./src/5.ajax'); // 如果真是的文件里的方法也要测试但是mock的没有 还需要引用真实的方法
// mock的文件自动会找 __mocks__
it('测试能否获取用户',async ()=>{
    let r = await fetchUser();
    expect(r).toEqual({name:'zf'})
})

it('测试能否获取用户1',async ()=>{
    let r = await fetchList();
    expect(r).toEqual(['zs','lisi'])
})

it('测试求和函数', ()=>{
    expect(sum(1,1)).toBe(2)
});

// 一般如果希望复写某个文件的测试逻辑 我们会选择这种方法

// 下周3 开始写组件
// button input 架子打出来 github / npm 持续继承
// 下周日 ts课