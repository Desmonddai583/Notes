import Counter from './src/7.conter';
let counter; // 作用域的概念

describe('作用域',()=>{
    beforeAll(()=>{ // 只走一次
        console.log('before all')
    })
    beforeEach(()=>{ // 每个用例执行前 都会执行此方法
        counter = new Counter
        console.log('before each')
    })
    afterEach(()=>{ // 每个用例执行前 都会执行此方法
        counter = new Counter
        console.log('after each')
    })
    afterAll(()=>{
        console.log('after all')
    })
    // 希望每个用例之间都没有任何关系
    it('测试加5',()=>{
        counter.add(5);
        expect(counter.count).toBe(5);
    })
})
it('测试-5',()=>{
    counter = new Counter
    counter.minus(5);
    expect(counter.count).toBe(-5);
})
it('测试+5 -5',()=>{
    counter = new Counter
    counter.add(5).minus(5);
    expect(counter.count).toBe(0);
})