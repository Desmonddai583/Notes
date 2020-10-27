let fs = require('fs'); // 文件系统 fs.open fs.write fs.read
let path = require('path');

// 怎么创建文件夹
// fs.mkdirSync
// 目录创建必须保证父级存在才能创建
fs.mkdir('a/b/c',function(err){
    console.log(err);
});


// 创建目录 makep  mkdir a/b/c
// 同步创建 性能低

fs.rmdirSync('a');
fs.rmdir('a',()=>{});

fs.unlinkSync('a.js');
fs.unlink('a.js',()=>{})




// 异步删除 promise
function removePromise(dir){
    return new Promise(function(resolve,reject){
        fs.stat(dir,function(err,stat){
            if(stat.isDirectory()){
                fs.readdir(dir,function(err,files){ 
                    files = files.map(file=>path.join(dir,file)); // [a/b,a/e,a/1.js]
                    files = files.map(file=>removePromise(file))
                    Promise.all([files]).then(function(){
                        fs.rmdir(dir,resolve);
                    });
                })
            }else{ // 如果是文件 删除文件 直接变成成功态即可
                fs.unlink(dir,resolve)
            }
        })
       
    })
}
removePromise('a').then(function(){
    console.log('删除')
});



// 同步深度删除
function removeDir(dir) {
    let files = fs.readdirSync(dir);// 读取到所有内容
    for (var i = 0; i < files.length; i++) {
        let newPath =path.join(dir,files[i]);
        let stat = fs.statSync(newPath);
        if(stat.isDirectory()){
            // 如果是文件夹 就递归走下去
            removeDir(newPath); // 递归
        }else{
            fs.unlinkSync(newPath);
        }
    }
    fs.rmdirSync(dir); // 如果文件夹是空的就将自己删除掉
}
removeDir('a');

// 异步深度删除
function rmdir(dir,callback){
    console.log(dir);
    fs.readdir(dir,function(err,files){
        // 读取到文件
        function next(index){
            if(index===files.length) return fs.rmdir(dir,callback);
            let newPath = path.join(dir,files[index]);
            fs.stat(newPath,function(err,stat){
                if(stat.isDirectory()){ // 如果是文件夹
                    // 要读的是b里的第一个 而不是去读c
                    // 如果b里的内容没有了 应该去遍历c
                    rmdir(newPath,()=>next(index+1));
                }else{
                    // 删除文件后继续遍历即可
                    fs.unlink(newPath,()=>next(index+1))
                }
            })
        }
        next(0);
    });
}
rmdir('a',function(){
    console.log('删除成功');
});


// 同步广度删除
function preWide(dir){
    let arrs = [dir]; // 存放目录结构的数组
    let index = 0; // 指针
    let current;
    while(current = arrs[index++]){ // current可能是文件
        let stat = fs.statSync(current);
        if(stat.isDirectory()){
            let files = fs.readdirSync(current); // [b,c]
            // [a,a/b,a/c,a/b/d,a/b/e,a/c/m];
            arrs = [...arrs,...files.map(file=>{
                return path.join(current,file)
            })];
        }
    }
    for(var i = arrs.length-1 ;i>=0;i--){
        let stat = fs.statSync(arrs[i]);
        if(stat.isDirectory()){
            fs.rmdirSync(arrs[i]);
        }else{
            fs.unlinkSync(arrs[i]);
        }
    }
}
preWide('a');

// 异步广度删除
function wide(dir,callback){
    // 目录是不是文件
    let arr = [dir];
    let index = 0;
    function rmdir(){
        function next(){
            let current = arr[--index];
            if(!current) return callback();
            fs.stat(current,function(err,stat){
                if(stat.isDirectory()){
                    fs.rmdir(current,next)
                }else{
                    fs.unlink(current,next)
                }
            })
        }
        next();
    }
    function next(){
        if(index === arr.length) return rmdir()
        let current = arr[index++];
        fs.stat(current,function(err,stat){
            if(stat.isDirectory()){
                fs.readdir(current,function(err,files){ // [b,c]
                    arr = [...arr,...files.map(file=>{
                        return path.join(current,file);
                    })];
                    next();
                });
            }else{
                next();
            }
        })
    }
    next();
}

// fs.statSync
fs.stat('a',function(err,stat){ // 文件夹的状态
    // stat对象可以判断是文件还是文件夹,如果文件不存在则会出err
    console.log(stat.isFile());
    // 读取当前文件夹下的内容
     if(stat.isDirectory()){
         fs.readdir('a',function(err,files){
            console.log(files)
         })
     }
})


// 记住：如果是异步的永远不能用for循环 
function mkdirSync(dir,callback){
    let paths = dir.split('/');
    function next(index){
        if(index>paths.length) return callback();
        let newPath = paths.slice(0,index).join('/');
        fs.access(newPath,function(err){
            if(err){ // 如果文件不存在就创建这个文件
                fs.mkdir(newPath,function(err){
                    next(index+1);// 创建后 继续创建下一个
                })
            }else{
                next(index+1); //这个文件夹存在了 那就创建下一个文件夹
            }
        })
    }
    next(1);
}
mkdirSync('a/e/w/q/m/n',function(){
    console.log('完成')
});



function makep(dir) {
    let paths = dir.split('/');
    for (let i = 1; i <= paths.length; i++) {
        let newPath = paths.slice(0, i).join('/');
        // 创建目录需要先干一件事
        try {
            fs.accessSync(newPath, fs.constants.R_OK);
        } catch (e) {
            fs.mkdirSync(newPath)
        }
    }
}
makep('a/b/c/d/e');  // a   a/b