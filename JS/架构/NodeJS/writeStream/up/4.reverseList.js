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
            let head = this.head;
            this.head = new Node(element, head);
        } else {
            let prevNode = this._node(index - 1); 
             prevNode.next = new Node(element, prevNode.next)
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
            this.head = this.head.next;
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
    // reverseList(){  // 1 2
    //     let head = this.head;
    //     function reverse(head) {
    //         // 需要做终止条件
    //         if(head == null || head.next === null) return head
    //         let newHead = reverse(head.next); // 可以找到链表最终的节点
    //         head.next.next = head;
    //         head.next = null;
    //         return newHead
    //     }
    //     return reverse(head);
    //     // 更新原来的链表
    //     // this.head = newHead;
    // }
    reverseList(){ // 非递归
        let head = this.head;
        // 如果只有一个元素 或者什么都没有 就不需要反转
        if(head == null || head.next === null) return head; 
        let newHead = null;
        while(head){
            let temp = head.next; // 保存2节点
            head.next = newHead; // 将1 指向null
            newHead = head; // 将新的链表头 指向1
            head = temp; // 让老的头指向2
        }
        return newHead;
    }
}
let ll = new LinkedList();
ll.add(1);
ll.add(2);
ll.add(3);
ll.add(4);
console.log(ll.reverseList())


// head -> 1 -> 2 -> null
// head -> 2 -> 1 -> null