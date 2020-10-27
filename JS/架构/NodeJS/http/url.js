let str = 'http://username:auth@www.baidu.com:8080/a?a=1';

let url = require('url');
let {pathname,query,hostname} = url.parse(str,true);
console.log() ; // true表示将查询字符串转化成对象

Url {
    protocol: 'http:',
    slashes: true,
    auth: 'username:auth',
    host: 'www.baidu.com:8080',
    port: '8080', 
    hostname: 'www.baidu.com',  √
    hash: null,
    search: '?a=1',
    query: [Object: null prototype] { a: '1' },  √
    pathname: '/a',   √
    path: '/a?a=1',
    href: 'http://username:auth@www.baidu.com:8080/a?a=1' }

