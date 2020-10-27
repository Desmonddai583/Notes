
// 准备2个栈：inStack、outStack
//   入队时，push 到 inStack 中
//   出队时
//     如果 outStack 为空，将 inStack 所有元素逐一弹出，push 到 outStack，outStack 弹出栈顶元素
//     如果 outStack 不为空， outStack 弹出栈顶元素

package 栈;

import java.util.Stack;

public class _232_用栈实现队列 {
	private Stack<Integer> inStack;
	private Stack<Integer> outStack;

    /** Initialize your data structure here. */
    public _232_用栈实现队列() {
    	inStack = new Stack<>();
    	outStack = new Stack<>();
    }
    
    /** 入队 */
    public void push(int x) {
        inStack.push(x);
    }
    
    /** 出队 */
    public int pop() {
    	checkOutStack();
    	return outStack.pop();
    }
    
    /** 获取队头元素 */
    public int peek() {
    	checkOutStack();
    	return outStack.peek();
    }
    
    /** 是否为空 */
    public boolean empty() {
    	return inStack.isEmpty() && outStack.isEmpty();
    }
    
    private void checkOutStack() {
    	if (outStack.isEmpty()) {
        	while (!inStack.isEmpty()) {
        		outStack.push(inStack.pop());
        	}
        }
    }
}
