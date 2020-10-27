const express = require('./express');


const app = express();

// 参数路由 /name/1/2  => {id:1,age:2}
app.get('/name/:id/:age',function (req,res) {
    res.end(JSON.stringify(req.params))
});
app.listen(3000);


//  /name/1/2    /name/:id/:age    => {id:1,age:2}

// const requestUrl = '/name/1/2/3'
// const configUrl = '/name/:id/:age'
// let arr = [];
// let str = configUrl.replace(/:([^\/]+)/g,function () {
//     arr.push(arguments[1]);
//     return '([^\/]+)'
// });
// console.log(requestUrl.match(new RegExp('^'+str+'$')),arr)


// let pathToRegExp = require('path-to-regexp');

// let arr = []
// let r  =pathToRegExp('/name/:id/:name',arr);
// console.log(r); // /^\/name\/(?:([^\/]+?))\/(?:([^\/]+?))\/?$/i
