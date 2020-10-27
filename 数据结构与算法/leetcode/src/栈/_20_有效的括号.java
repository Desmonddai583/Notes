
// 有效的括号
//   1. 遇见左字符，将左字符入栈
//   2. 遇见右字符
//     如果栈是空的，说明括号无效
//     如果栈不为空，将栈顶字符出栈，与右字符之匹配
//       如果左右字符不匹配，说明括号无效
//       如果左右字符匹配，继续扫描下一个字符
//   3. 所有字符扫描完毕后
//     栈为空，说明括号有效
//     栈不为空，说明括号无效

package 栈;

import java.util.HashMap;
import java.util.Stack;

public class _20_有效的括号 {
	private static HashMap<Character, Character> map = new HashMap<>();
	static {
		// key - value
		map.put('(', ')');
		map.put('{', '}');
		map.put('[', ']');
	}
	
	public boolean isValid(String s) {
		Stack<Character> stack = new Stack<>();
		
		int len = s.length();
		for (int i = 0; i < len; i++) {
			char c = s.charAt(i);
			if (map.containsKey(c)) { // 左括号
				stack.push(c);
			} else { // 右括号
				if (stack.isEmpty()) return false;
				
				if (c != map.get(stack.pop())) return false;
			}
		}
		return stack.isEmpty();
    }
	
	public boolean isValid1(String s) {
		Stack<Character> stack = new Stack<>();
		
		int len = s.length();
		for (int i = 0; i < len; i++) {
			char c = s.charAt(i);
			if (c == '(' || c == '{' || c == '[') { // 左括号
				stack.push(c);
			} else { // 右括号
				if (stack.isEmpty()) return false;
				
				char left = stack.pop();
				if (left == '(' && c != ')') return false;
				if (left == '{' && c != '}') return false;
				if (left == '[' && c != ']') return false;
			}
		}
		return stack.isEmpty();
    }

	public boolean isValid2(String s) {
		while (s.contains("{}")
				|| s.contains("[]")
				|| s.contains("()")) {
			s = s.replace("{}", "");
			s = s.replace("()", "");
			s = s.replace("[]", "");
		}
		return s.isEmpty();
    }
	
}
