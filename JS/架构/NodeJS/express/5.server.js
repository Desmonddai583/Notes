const express = require('./express');
const app = express();

// express.Router  函数可以充当类和函数
const router = express.Router(); // 可以去产生一个单独的路由系统
const router1 = express.Router();
router.get('/add',function (req,res) {
    res.end('add')
})

router.get('/remove',function (req,res) {
    res.end('remove')
})

router1.get('/xxx',function (req,res,next) {
    res.end('xxx')
})  

// 当匹配到这个中间件的时候 /user/xxx
app.use('/user',router); // 将路由进行一个挂载操作
app.use('/user',router1); // 将路由进行一个挂载操作


app.listen(3000);

