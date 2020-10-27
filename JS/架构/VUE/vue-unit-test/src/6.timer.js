//  测试过多少秒 结果是怎样的


export const timer = (fn)=>{
    setInterval(() => {
        
        fn({name:'zf'})
    }, 5000);
}