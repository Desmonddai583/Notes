let EventEmitter = require('events');
let fs = require('fs');
class ReadStream extends EventEmitter {
    constructor(path, options = {}) {
        super();
        // 1.会将用户传入的参数全部放到实例上，这样方便后续使用
        this.path = path;
        this.flags = options.flags || 'r';
        this.mode = options.mode || 438;
        this.autoClose = options.autoClose || true;
        this.start = options.start || 0;
        this.end = options.end;
        this.highWaterMark = options.highWaterMark || 64 * 1024;

        // 读取文件每次都需要一个偏移量
        this.pos = this.start; // 每次读取时的偏移量

        // 打开文件
        this.open(); // 实现打开文件的操作

        this.flowing = false; // 默认叫非流动模式
        // 这个方法可以监听到用户调用on事件
        this.on('newListener', (type) => {
            if (type == 'data') {
                this.flowing = true;
                this.read(); // 开始读取文件即可
            }
        })

    }
    pause() {
        this.flowing = false;
        // 如果文件读取完毕 你也需要触发close事件
    }
    resume() {
        this.flowing = true;
        this.read();
    }
    open() {
        fs.open(this.path, this.flags, this.mode, (err, fd) => {
            if (err) {
                return this.emit('error', err)
            }
            // 文件打开后就拥有了文件描述符
            this.fd = fd;
            this.emit('open', fd)
        })
    }
    close() {
        fs.close(this.fd, () => {
            this.emit('close');
        });
    }
    read() {
        if (typeof this.fd !== 'number') {
            return this.once('open', this.read)
        }
        // 这里可以开始读取文件了
        let buffer = Buffer.alloc(this.highWaterMark);
        // 计算一下每次读取的个数 可能不会把文件读取完毕
        let howMuchToRead = this.end ? Math.min(this.end - this.pos + 1, this.highWaterMark) : this.highWaterMark
        fs.read(this.fd, buffer, 0, howMuchToRead, this.pos, (err, bytesRead) => {
            if (bytesRead) {

                this.pos += bytesRead;
                // 要根据读取的个数进行截取，将读取到的内容发射出来
                this.emit('data', buffer.slice(0, bytesRead));
                if (this.flowing) {
                    this.read();
                }
            } else {
                this.emit('end');
                this.close();
            }
        })
    }
    pipe(w) {
        this.on('data', (data) => {
            let flag = w.write(data);
            if (!flag) {
                this.pause(); // 如果已经超过写入的预估了 等待一会先别读取了
            }
        })
        w.on('drain', () => {
            this.resume();
        });
    }
}
module.exports = ReadStream