// fs fileSystem 文件系统 这里提供了很多方法 方法有同步的和异步的
// readFileSync readFile
// 异步的就多了一个callback callback的第一个参数是错误对象
let fs = require('fs');
let path = require('path');
// 同步的性能低 会阻塞主线程，能用异步就用异步 
// 读取文件的时候默认编码是null null代表的就是二进制
fs.readFile(path.join(__dirname,'1.txt'),{flag:'r'},function(err,data){
  if(err) return console.log(err);
  console.log(data);
});

// 以什么编码格式写入到文件内
// mode 权限 
// 0o666 表示可读可写
// chmod -R 777 *
fs.writeFile('./2.txt','hello',{mode:0o666},function(err){
    console.log(err);
})


let fs = require('fs');
let path = require('path');

function copy(source,target){
    fs.readFile(path.join(__dirname,source),function(err,data){
        if(err) return console.log(err);
        fs.writeFile(path.join(__dirname,target),data,function(err){
            if(err) console.log(err);
        })
    });
}
copy('1.txt','2.txt');

// 内存12g  读一个20g文件 肯定都不了
// 1g的文件 先弄个内存先读一下，马上再去写
// 限制读取个数 手动读取
// fs.open打开文件，先要打开文件 才能对文件进行操作

//fd file descriptor 文件描述符 他代表对当前文件的描述
// process.stdout.write(); // 标准输出1
// process.stderr.write();// 错误输出 2

// 读取
let buffer = Buffer.alloc(3);
fs.open(path.join(__dirname,'1.txt'),'r',0o666,function (err,fd) {
    // offset表示的是 buffer从那个开始存储
    // length就是一次想读几个
    // postion 代表的是文件的读取位置，默认可以写null 当前位置从0开始
    // length不能大于buffer的长度
    fs.read(fd,buffer,0,2,0,function(err,bytesRead){
        // bytesRead 读取到个数
        console.log(err,bytesRead);
    })
});

// 如果flag是a 那你写的position参数就不生效了
// fs.open(path.join(__dirname,'2.txt'),'r+',0o666,function(err,fd){
//     fs.write(fd,Buffer.from('珠峰'),0,3,3,function(err,byteWritten){
//         if(err) return console.log(err);
//         console.log(byteWritten)
//     })
// });

function copy(source,target){
    let size = 3; // 每次来三个
    let buffer = Buffer.alloc(3);
    fs.open(path.join(__dirname,source),'r',function(err,rfd){
        fs.open(path.join(__dirname,target),'w',function(err,wfd){
            function next(){
                fs.read(rfd,buffer,0,size,null,function(err,bytesRead){
                    if(bytesRead>0){ // 读取完毕了 没读到东西就停止了
                        fs.write(wfd,buffer,0,bytesRead,null,function(err,byteWritten){
                            next();
                        })
                    }else{
                        fs.close(rfd,function(){}); // 读取的

                        fs.fsync(wfd,function(){ // 确保内容 写入到文件中 
                            fs.close(wfd,function(){ // 写入的
                                console.log('关闭','拷贝成功')
                            })
                        })
                    }
                })
            }
            next();
        })
    });
}
copy('1.txt','2.txt');

// 文件打开是需要关闭的


fs.open(path.join(__dirname,'2.txt'),'w',function(err,fd){
   fs.write(fd,Buffer.from('珠峰'),0,6,0,function(err,byteWritten){
    // 当write方法触发了回调函数 并不是真正的文件背写入了，先把内容写入到缓存区
        // 强制将缓存区的内容 写入后再关闭文件
        fs.fsync(fd,function(){
            fs.close(fd,function(){
                console.log('关闭')
            })
        })
   })
});

//node版本至少是8.5版本
fs.copyFile(path.join(__dirname,'1.txt'),path.join(__dirname,'2.txt'),function(){
    console.log("拷贝成功");
});

// gulp监控文件有没有改动
// current是当前状态 prev是上一次的状态
fs.watchFile('./1.txt',function(current,prev){
    if(Date.parse(current.ctime)==0){ 
        console.log('删除')
    }else if(Date.parse(prev.ctime) === 0){
        console.log('创建')
    }else{
        console.log('修改');
    }
});

fs.rename('b','bbbbb')

fs.truncate('1.txt',5); //截断