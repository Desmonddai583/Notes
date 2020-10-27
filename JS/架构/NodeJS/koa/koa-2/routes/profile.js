const Router = require('@koa/router');
const router = new Router({
    prefix:'/profile'
});

router.get('/add',async ctx=>{
    ctx.body = '添加'
})
router.get('/remove',async ctx=>{
    ctx.body = '删除'
})

module.exports = router