import {fetchUser,fetchList} from './src/5.ajax';

// 我可以自己在根目录下建立一个__mocks__文件夹 来mock掉 第三方的模块 文件名要和模块名相同
it('测试能否获取用户',async ()=>{
    let r = await fetchUser();
    expect(r).toEqual({name:'zf'})
});