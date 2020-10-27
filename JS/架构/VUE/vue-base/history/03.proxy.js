// 如何用proxy 来实现响应式原理
let obj = {
    name: {
        name: 'jw'
    },
    arr: ['吃', '喝', '玩']
}
// 兼容性差  可以代理13种方法 set get
// defineProperty他只能对特定的属性 进行拦截
let handler = {
    // target 就是原对象 key就是当前取的是哪个值
    get(target,key){
        // console.log('收集依赖');
        if(typeof target[key] === 'object' && target[key] !== null){
            // 递归代理 只有取到对应值的时候 才会进行代理
            return new Proxy(target[key],handler);
        }
        // Reflect 反射 这个方法里包含了很多的api
        return Reflect.get(target,key); // target[key]
    },
    // 知道这个机制 先更改索引 在更新长度
    set(target,key,value){ // [1,2,3].length = 4; 
        // 判断一下 当前是新增操作还是修改操作
        let oldValue = target[key]; // [1,2,3,123]
        if(!oldValue){
            console.log('新增属性')
        }else if(oldValue !== value){
            console.log('修改属性')
        }
        // target[key] = value; // 设置时 如果设置不成功，设置不成功不会报错，对象不可配置
        return Reflect.set(target,key,value);
    }
}
let proxy = new Proxy(obj,handler)
// 懒代理
// proxy.name.name  = 123;
// proxy.arr[0] = 100; 
proxy.xxx =  100;