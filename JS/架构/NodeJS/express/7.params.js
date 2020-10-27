const express = require('./express');


const app = express();
// id  = 10 我需要将id 变成100
// name = zf 我希望将 name变成 zfjg


app.param('id', function (req, res, next, value, key) {
    console.log('id', 1)
    if (req.params.id == 10) {
        req.params.id = 100;
        next();
    } else {
        next();
    }
})
app.param('id', function (req, res, next, value, key) {
    console.log('id', 2)
    if (req.params.id == 20) {
        req.params.id = 200;
        next();
    } else {
        next();
    }
})
app.param('name', function (req, res, next, value, key) {
    console.log('name', 1)
    if (req.params.name === 'zf') {
        req.params.name = 'zfjg'
        next();
    } else {
        next();
    }
})
app.param('name', function (req, res, next, value, key) {
    console.log('name', 2)
    if (req.params.name === 'z') {
        req.params.name = 'zf'
        next();
    } else {
        next();
    }
})
// 每一个框架都会用到发布订阅模式 koa EventEmitter express他是自己写的
app.get('/name/:id/:name', function (req, res) {
    res.end(JSON.stringify(req.params));
})


app.listen(3000);