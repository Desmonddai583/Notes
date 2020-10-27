import {
    parser,
    stringify
} from './src/1.parser'

// jest mocha chai(断言) sinon
describe('分类1', () => {
    it('1.我希望测试当前parser方法是否ok?', () => {
        expect(parser('name=zf&age=10')).toEqual({
            name: 'zf',
            age: '10'
        })
    });
})
describe('分类2',()=>{
    it('2.测试stringify方法是否ok?', () => {
        expect(stringify({
            name: 'zf',
            age: 10
        })).toEqual('name=zf&age=10')
    })
})

