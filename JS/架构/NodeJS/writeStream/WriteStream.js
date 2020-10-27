let fs = require('fs');
let EventEmitter = require('events');
let LinkedList = require('./linkList');
class Queue {
    constructor() {
        this.linkedList = new LinkedList();
    }
    enQueue(data) {
        this.linkedList.add(data);
    }
    deQueue() {
        let node = this.linkedList.remove(0);
        return node;
    }
}
class WriteStream extends EventEmitter {
    constructor(path, options = {}) {
        super();
        this.path = path;
        this.flags = options.flags || 'w';
        this.autoClose = options.autoClose || true;
        this.start = options.start || 0;
        this.encoding = options.encoding || 'utf8';
        this.highWaterMark = options.highWaterMark || 16 * 1024;

        this.open();

        // 内部需要的属性
        this.needDrain = false; // 是否需要触发drain事件
        this.offset = this.start; // 写入的偏移量
        this.cache = new Queue();
        // 缓存结构可以使用链表结构
        this.len = 0; // 维护正在写入的个数  3 
        this.writing = false; //  默认不是正在写入，调用write时会像文件中写入
    }
    open() {
        fs.open(this.path, this.flags, (err, fd) => {
            if (err) {
                this.emit('error', err);
            } else {
                this.fd = fd;
                this.emit('open', fd);
            }
        })
    }
    write(chunk, encoding='utf8', cb=()=>{}) {
        // 这里拿不到fd的
        // chunk 可能是一个汉字 需要转换成buffer
        chunk = Buffer.isBuffer(chunk) ? chunk : Buffer.from(chunk);
        this.len += chunk.length;
        // 当前写入的个数 小于 预期的数量
        let flag = this.len < this.highWaterMark
        this.needDrain = !flag; // 当达到或者超过预期时 需要触发drain事件

        if (this.writing) {
            // 增加到链表中 先存起来
            this.cache.enQueue({
                chunk,
                encoding,
                cb
            });
        } else {
            // 要真的像文件中写入
            this.writing = true;
            this._write(chunk, encoding, () => {
                // 这里可以增加一些自身的逻辑
                cb();
                // 要去情空缓存
                this.clearBuffer(); // 情空缓存区
            });
        }
        return flag; // 标识可以继续写入，没有达到预估的值
    }
    clearBuffer() {
        let data = this.cache.deQueue();
        if (data) {
            data = data.element;
            // 要情空缓存
            this._write(data.chunk, data.encoding, () => {
                data.cb && data.cb();
                this.clearBuffer(); // 继续情空缓存
            })
        } else {
            this.writing = false; // 已经完成写入
            if (this.needDrain) { // 并且需要触发drain事件
                this.needDrain = false;
                this.emit('drain'); // 触发drain事件
            }
        }
    }
    _write(chunk, encoding, cb) {
        if (typeof this.fd !== 'number') {
            return this.once('open', () => this._write(chunk, encoding, cb));
        }
        fs.write(this.fd, chunk, 0, chunk.length, this.offset, (err, written) => {
            if (err) {
                this.emit('error', err);
            };
            this.offset += written;
            this.len -= written;
            cb(); // 当第一次写完之后 需要情空缓存中的数据
        });
    }
}
module.exports = WriteStream;


