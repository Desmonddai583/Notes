const fs = require('fs').promises;
const path = require('path');
const render = (template, data) => {
    let head = "let str = ''\r\nwith(data) {\r\nstr=`"
    template = template.replace(/<%=([\s\S]+?)%>/g,function () {
        return '${'+arguments[1]+'}'
    })
    let content = template.replace(/<%([\s\S]+?)%>/g, function () {
        return '`\r\n' + arguments[1] + '\r\nstr+=`'
    });
    let tail = '`}\r\nreturn str'
    let htmlStr = head + content + tail;
    return new Function('data', htmlStr)(data)
}
const views = (dirname,{map}) => {
    return async (ctx,next)=>{
        ctx.render = async (filename,data)=>{
           let str =  await fs.readFile(path.join(dirname,filename) + '.html','utf8');
           ctx.body = render(str,data);
        }
        await next();
    }
}
module.exports = views;


