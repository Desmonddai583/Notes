// 实现一个拷贝功能 fs.readFile  fs.writeFile
// fs.copy 文件过大事不能拷贝的

// 淹没用户的可用内存

// 手动去读取文件中的内容 可用指定位置来读
// fs.open  fs.read  fs.write  fs.close (参数比较多)

// 读取操作 是将内容写到内存中
// 写操作的话 是将内存中的内容读取出来
let fs = require('fs');
let path = require('path');


// 表示我要打开这个文件去读取文件中的内容
// 权限分为三种 读取权限 写入权限 执行权限
// rwx(表示自己用户是否可读可写可执行) rwx(我所属组是否有读写执行的权限) rwx


// fd 文件描述符 它代表了文件name.txt拥有了读取这个文件的权限 类型是一个number类型
// (1) 读取相关 指定范围和读取的格式来操作
// let buf = Buffer.alloc(3); // 将读取到的内容写入到buffer中
// fs.open(path.resolve(__dirname,'./name.txt'),'r',438,(err,fd)=>{
//     // fd 表示文件描述符 
//     // buf就是写入到哪个内存中
//     // 0 从buffer的哪个位置开始写入
//     // 3 表示的是写入多少个
//     // 0 代表的是从文件的哪个位置开始读取
//     fs.read(fd,buf,0,3,3,(err,bytesRead)=>{ // bytesRead 当前读取到的真实的个数 
//         console.log(buf.toString()); // fs.close()
//     })
// });

// (2) 写相关的
// let buf = Buffer.from('珠峰机构');
// fs.open(path.resolve(__dirname, 'name.txt'), 'w', 0o666,(err, fd) => {
//     // 将buffer的偏移第九个的位置 读取3个出来，写入到文件的第0个位置
//     fs.write(fd, buf, 9, 3, 0, (err, written) => {
//         console.log('文件写入成功'); // fs.close(0)
//     })
// });

// copy  u 盘
const BUFFER_SIZE = 5;
const buffer = Buffer.alloc(BUFFER_SIZE);
let readOffset = 0;

// 异步嵌套的问题 嵌套了很多层

// 发布订阅模式  讲读写操作进行解耦，解耦后 就可以把读写操作进行分离
// 文件流：可读流 可写流
fs.open('./name.txt', 'r', (err, rfd) => {
    fs.open('./name1.txt', 'w', (err, wfd) => {
        function next(){
            // bytesRead 代表的是真实读取到的个数
            fs.read(rfd, buffer, 0, BUFFER_SIZE, readOffset, (err, bytesRead) => {
                // 写的话可以不填写偏移量
                if(!bytesRead){
                    fs.close(rfd,()=>{});
                    fs.close(wfd,()=>{});
                    return;
                }
                readOffset += bytesRead;
                fs.write(wfd, buffer, 0, bytesRead, (err, written) => {
                    next();
                })
            })
        }
        next();
    });
});