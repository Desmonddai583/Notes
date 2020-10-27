const Koa = require('koa');
const Router = require('@koa/router');
const multer = require('@koa/multer');

var cors = require('koa-cors');
const app = new Koa();
app.use(cors());
const router = new Router();
const upload = multer({
    dest: 'uploads/'
}); // note you can pass `multer` options here

// add a route for uploading multiple files
router.post(
    '/upload',
    upload.fields([{
        name: 'avatar',
        maxCount: 5
    }]),
    ctx => {
        console.log('ctx.request.files', ctx.request.files);
        console.log('ctx.files', ctx.files);
        console.log('ctx.request.body', ctx.request.body);
        console.log(ctx.request.files)
        let r = ctx.request.files.avatar.map(item => ({
                url: item.path,
                name: item.originalname
        }))
        ctx.body = r;
    }
);



// add the router to our app
app.use(router.routes());
app.use(router.allowedMethods());

// start the server
app.listen(3000);