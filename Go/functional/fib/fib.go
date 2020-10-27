package fib

// Fibonacci 定義斐波那契實現
// 1, 1, 2, 3, 5, 8, 13, ...
func Fibonacci() func() int {
	a, b := 0, 1
	return func() int {
		a, b = b, a+b
		return a
	}
}
