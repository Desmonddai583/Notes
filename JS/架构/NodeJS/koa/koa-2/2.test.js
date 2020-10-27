let fs = require('fs');
let path = require('path')
// 如何实现模板引擎  vue (template => render)

let str = fs.readFileSync(path.resolve(__dirname, 'views/index.html'), 'utf8');
let ejs = require('ejs');

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

let r = render(str, {
    name: 'zf',
    age: 11,
    arr: [1, 2, 3]
});
console.log(r);