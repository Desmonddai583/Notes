
export default {
    get(url){
        return new Promise((resolve,reject)=>{
            if(url === '/user'){
                resolve({name:'zf'})
            }
            if(url === '/list'){
                resolve(['zs','lisi'])
            }
        })
    }
}