const Router = require('@koa/router');
const router = new Router();

router.get('/upload',async ctx=>{
    await ctx.render('index.html')
})
router.post('/upload',async ctx=>{
    ctx.body = ctx.request.files
})

module.exports = router