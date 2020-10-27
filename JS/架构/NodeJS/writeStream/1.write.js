let fs = require('fs');
let path = require('path');
let WriteStream = require('./WriteStream');
let ws = new WriteStream(path.resolve(__dirname, 'name.txt'), {
// let ws = fs.createWriteStream(path.resolve(__dirname, ' name.txt'), {
    autoClose: true,
    flags: 'w',
    mode: 0o666,
    highWaterMark: 3,
    start:0,
    encoding: 'utf8'
});
ws.on('open',function (fd) {
    console.log(fd,'open')
})
let flag = ws.write('1','utf8', function () {
    console.log('ok1')
})
console.log(flag);
flag = ws.write('2','utf8', function () {
    console.log('ok1')
})
console.log(flag);
flag = ws.write('3','utf8',function () {
    console.log('ok1')
})
console.log(flag);
