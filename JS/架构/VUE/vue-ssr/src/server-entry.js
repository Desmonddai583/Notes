import createApp from './app.js';

// 这里服务端渲染要求打包后的结果需要返回一个函数

// 服务端稍后会调用函数 传递一些参数到这个函数中
export default (context)=>{ // 后端执行的
    return new Promise((resolve,reject)=>{
        let {app,router,store} = createApp();
        router.push(context.url);
        // 等待路由中的钩子函数 执行完毕后才执行渲染逻辑
        router.onReady(()=>{
            // 我们应该看一下 到底有没有这个路径 如果有这个路径 才去渲染
            let matchComponents = router.getMatchedComponents(); // 查看是否路由对应有匹配到的组件
            if(!matchComponents.length){
                return reject({code:404}); // 配置404页面
            }

            // matchComponents 是当前路由匹配到的组件 这个组件里可能会写asyncData方法
            Promise.all(matchComponents.map(comp=>{
                return comp.asyncData && comp.asyncData(store) // 这里你可能更改了状态。最终渲染的时候 我希望拿到更改的状态 
            })).then(()=>{ // 默认渲染时window.__initState__
                context.state = store.state; // 将刚才在服务端调用的vuex的结果放到当前的上下汶上
                resolve(app)
            },err=>{
                reject(err); // 如果请求失败了 会不挂
            })
        },reject);
    })
}