class Node {
    constructor(element, next) {
        this.element = element;
        this.next = next;
    }
}
class LinkedList { // 对数据的增删改查
    constructor() {
        this.head = null;
        this.size = 0;
    }
    _node(index) {
        // 获取索引也可能有越界问题
        if (index < 0 || index >= this.size) throw new Error('边界越界')
        let current = this.head;
        // 从0开始找 找到索引处
        for (let i = 0; i < index; i++) {
            current = current.next; // 不停的找下一个元素 找到索引的位置
        }
        return current;
    }
    // 添加节点
    add(index, element) { // 在尾部添加  在中间添加
        if (arguments.length === 1) {
            element = index;
            index = this.size;
        }
        if (index < 0 || index > this.size) throw new Error('边界越界')
        if (index == 0) {
            let head = this.head; // null 
            this.head = new Node(element, head);
        } else {
            // 获取当前要添加的索引的上一个元素 
            let prevNode = this._node(index - 1); // 获取上一个节点 
            // 让上一个节点的下一个节点指向新增的节点，当前这个节点的下一个 指向的是prevNode.next
            prevNode.next = new Node(element, prevNode.next)
        }
        this.size++;
    }
    // 获取节点
    get(index) {
        return this._node(index);
    }
    // 设置节点
    set(index, element) {
        let node = this._node(index);
        node.element = element; // 修改节点内容
    }
    // 删除指定索引
    remove(index) {
        let node;
        if (index === 0) {
            node = this.head;
            if(!node){
                return undefined;
            }
            this.head = this.head.next;
        } else {
            let prevNode = this._node(index - 1);
            node = prevNode.next;
            prevNode.next = prevNode.next.next;
        }
        this.size--;
        return node;
    }
    // 清空链表
    clear() {
        this.head = null;
        this.size = 0;
    }
}

module.exports = LinkedList