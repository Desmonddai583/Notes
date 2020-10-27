// 异步深度删除
let fs = require('fs').promises;
let path = require('path');
function rmdir(p, cb) {
    // co库 next
    fs.stat(p, function (err, statObj) {
        if (statObj.isDirectory()) {
            fs.readdir(p, function (err, dirs) {
                dirs = dirs.map(dir => path.join(p, dir)); // a/b
                let index = 0;
                function next() {
                    // 等到儿子都删除完毕后 触发自己的删除
                    if(index == dirs.length) return fs.rmdir(p,cb);
                    let current = dirs[index++];
                    // 将第二个路径的删除放到回调中 等待第一个删除完毕后 ，进行删除
                    rmdir(current,next);
                }
                next();
            });
        } else {
            fs.unlink(p, cb); // 删除文件
        }
    });
}
rmdir('a',()=>{})
// 以后我们删除文件 rm -rf
// function rmdir(p, cb) {
//     // co库 next
//     fs.stat(p, function (err, statObj) {
//         if (statObj.isDirectory()) {
//             fs.readdir(p, function (err, dirs) {
//                 dirs = dirs.map(dir => path.join(p, dir));
//                 let index = 0; // 并发的解决方案 在计数器
//                 if(dirs.length === 0){ // 如果文件夹是空文件夹直接删除
//                     return fs.rmdir(p,cb)
//                 }
//                 function done(){ // 当子文件夹都删除完毕后 删除自己
//                     index ++ ;
//                     if(index === dirs.length){
//                         fs.rmdir(p,cb);
//                     }
//                 }
//                 for(let i =0 ; i< dirs.length;i++){
//                     let dir = dirs[i];
//                     rmdir(dir,done); // 并发删除 同时删除同级别的目录
//                 }
//             });
//         } else {
//             fs.unlink(p, cb); // 删除文件
//         }
//     });
// }
// rmdir('a', function () {
//     console.log('删除成功')
// });

// async + await + promise

// async function rmdir(p){
//     let statObj = await fs.stat(p);
//     if(statObj.isDirectory()){
//         let dirs = await fs.readdir(p);
//         // 等待子目录删除完毕后 删除自己
//         dirs = dirs.map(dir => rmdir(path.join(p, dir)));
//         await Promise.all(dirs);
//         await fs.rmdir(p);
//     }else{
//         await fs.unlink(p);
//     }
// }
// rmdir('a').then(()=>{
//     console.log('删除成功')
// })