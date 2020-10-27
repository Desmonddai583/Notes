// 线性结构
// 数组  队列  栈  链表
// 队列 先进先出  [].push  [].unshift

// 链表的概念 
// 单向链表  
// 单向循环链表
// 双向链表  最常用
// 双向循环链表
// 环形链表
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
        if (index === 0) {
            this.head = this.head.next;
        } else {
            let prevNode = this._node(index - 1);
            prevNode.next = prevNode.next.next;
        }
        this.size--;
    }
    // 清空链表
    clear() {
        this.head = null;
        this.size = 0;
    }
}
let ll = new LinkedList();
ll.add(1);
ll.add(2);
ll.remove(1)
console.log(ll)



// 栈  先进后出  [].push  [].pop
// 作业如何使用栈来实现校验标签是否闭合：
// 考虑用户写的标签字符串是否闭合 （不用考虑自闭合标签）
// 如果都是开始标签 就不听的像栈里存放 正则实现
// 如果是闭合标签我就校验当前的闭合标签和栈里的最后一个
// <div><div></div></div>  = false 
// <div><p><a></a></p></div> = true
// 栈的应用场景？  浏览器历史 （前进后退）