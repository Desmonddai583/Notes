class Node {
    constructor(element, next) {
        this.element = element;
        this.next = next;
    }
}
class LinkedList {
    constructor() {
        this.head = null;
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
        if (index == 0) {
            // 让头指向新头
            let head = this.head;
            let newHead = new Node(element, head);
            // 让尾巴 指向新头,但是链表可能为空
            let last = this.size === 0? newHead : this._node(this.size-1);
            this.head = newHead;
            last.next = newHead;
        } else {
            // 在中间添加 是不影响 循环效果的 只有在第一个添加的时候 需要有一个尾部
            // 指向头部的过程
            let prevNode = this._node(index - 1); 
            prevNode.next = new Node(element, prevNode.next);
        }
        this.size++;
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

// ll.add(1);
// ll.add(2);
// ll.add(3);
// ll.add(4);
console.log(ll)


// head -> 1 -> 2 -> null
// head -> 2 -> 1 -> null