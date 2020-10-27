let Promise = require('./promise');


let p = new Promise((resolve,reject)=>{
    reject('hello');
})

p.then().then().then().then(null,function (err) {
    console.log(err);
});

// promise all race catch finally promisify

