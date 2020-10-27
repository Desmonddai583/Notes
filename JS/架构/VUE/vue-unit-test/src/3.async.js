export const getDataCallback = (fn) => {
    setTimeout(() => {
        fn({name:'zf'});
    }, 1000);
}

export const getDataPromise = () => {
    return new Promise((resolve,reject)=>{
        setTimeout(() => {
            resolve({name:'zf'});
        }, 1000);
    })
}