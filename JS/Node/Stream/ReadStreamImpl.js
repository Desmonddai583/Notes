let EventEmitter = require('events');
let fs = require('fs');
class ReadStream extends EventEmitter {
    constructor(path,options){
        super();
        this.path = path;
        this.flags = options.flags || 'r';
        this.autoClose = options.autoClose || true;
        this.highWaterMark = options.highWaterMark|| 64*1024;
        this.start = options.start||0;
        this.end = options.end;
        this.encoding = options.encoding || null

        this.open();//打开文件 fd

        this.flowing = null; // null就是暂停模式
        // 看是否监听了data事件，如果监听了 就要变成流动模式

        // 要建立一个buffer 这个buffer就是要一次读多少
        this.buffer = Buffer.alloc(this.highWaterMark);

        this.pos = this.start; // pos 读取的位置 可变 start不变的
        this.on('newListener',(eventName,callback)=>{
            if(eventName === 'data'){
                // 相当于用户监听了data事件
                this.flowing  = true;
                // 监听了 就去读
                this.read(); // 去读内容了
            }
        })
    }
    read(){
        // 此时文件还没打开呢
        if(typeof this.fd !== 'number'){
            // 当文件真正打开的时候 会触发open事件，触发事件后再执行read，此时fd肯定有了
            return this.once('open',()=>this.read())
        }
        // 此时有fd了
        // 应该填highWaterMark?
        // 想读4个 写的是3  每次读3个
        // 123 4
        let howMuchToRead = this.end?Math.min(this.highWaterMark,this.end-this.pos+1):this.highWaterMark;
        fs.read(this.fd,this.buffer,0,howMuchToRead,this.pos,(err,bytesRead)=>{
            // 读到了多少个 累加
            if(bytesRead>0){
                this.pos+= bytesRead;
                let data = this.encoding?this.buffer.slice(0,bytesRead).toString(this.encoding):this.buffer.slice(0,bytesRead);
                this.emit('data',data);
                // 当读取的位置 大于了末尾 就是读取完毕了
                if(this.pos > this.end){
                    this.emit('end');
                    this.destroy();
                }
                if(this.flowing) { // 流动模式继续触发
                    this.read(); 
                }
            }else{
                this.emit('end');
                this.destroy();
            }
        });
    }
    resume(){
        this.flowing = true;
        this.read();
    }
    pause(){
        this.flowing = false;
    }
    destroy(){
        // 先判断有没有fd 有关闭文件 触发close事件
        if(typeof this.fd ==='number'){
            fs.close(this.fd,()=>{
                this.emit('close');
            });
            return;
        }
        this.emit('close'); // 销毁
    };
    open(){
        // copy 先打开文件
        fs.open(this.path,this.flags,(err,fd)=>{
            if(err){
                this.emit('error',err);
                if(this.autoClose){ // 是否自动关闭
                    this.destroy();
                }
                return;
            }
            this.fd = fd; // 保存文件描述符
            this.emit('open'); // 文件打开了
        });
    }
}
module.exports = ReadStream;