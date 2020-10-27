class Node {
    constructor(element, prev,next) {
        this.element = element;
        this.next = next;
        this.prev = prev;
    }
}
// 双向链表的好处 不光有头 还有尾 
// 查找的时候 可以判断当前是从头查找还是从尾查找
// 节点互相记住

// 1.实现双向链表的查询和删除
// 2.实现双向循环链表


class LinkedList {
    constructor() {
        this.head = null;
        this.tail = null;
        this.size = 0;
    }
    _node(index) {
        if (index < 0 || index >= this.size) throw new Error('边界越界')
        let current = this.head;
        for (let i = 0; i < index; i++) {
            current = current.next; 
        }
        return current;
    }
    add(index, element) { 
        if (arguments.length === 1) {
            element = index;
            index = this.size;
        }
        if (index < 0 || index > this.size) throw new Error('边界越界')
        if(index === this.size){
            // 向后添加
            let tail = this.tail;
            this.tail = new Node(element,tail,null);
            if(tail == null){
                this.head = this.tail; // 直接头尾指向的都是同一个人
            }else{
                tail.next = this.tail; // 互相记忆
            }
        }else{
            // 像前添加 像中间添加 
            // 添加时 我需要拿到当前添加的位置节点, 获取他的上一个
            let nextNode = this._node(index);
            let prevNode = nextNode.prev; // 有可能当前值有一个元素 
            let node = new Node(element,prevNode,nextNode); // 创建了2个线 让当前节点记住他的上一个和下一个是谁
            nextNode.prev = node; // 让前后在记住当前新增的
            if(prevNode === null){
                this.head = node; // 如果没有上一个 那你添加的就是头
            }else{
                prevNode.next = node;
            }
            this.size++;
        }
    }
    get(index) {
        return this._node(index);
    }
    set(index, element) {
        let node = this._node(index);
        node.element = element; 
    }
    remove(index) {
        if (index === 0) {
            if(this.size == 1){ // 如果只有一个 就直接删除这个即可
                this.head = null;
            }else{ // 如果要是多个就让头指向他的下一个，并且让尾指向这个头
                let last = this._node(this.size-1); // 取到最后一个
                this.head = this.head.next; // 让头部删除掉
                last.next = this.head;  // 让尾部的下一个指向新头
            }
        } else {
            let prevNode = this._node(index - 1);
            prevNode.next = prevNode.next.next;
        }
        this.size--; 
    }
    clear() {
        this.head = null;
        this.size = 0;
    }
}
let ll = new LinkedList();

ll.add(1);
ll.add(2);
console.log(ll)


// head -> 1 -> 2 -> null
// head -> 2 -> 1 -> null