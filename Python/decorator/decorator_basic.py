def memo(func):
    cache = {}
    def wrap(*args):
        res = cache.get(args)
        if not res:
            res = cache[args] = func(*args)
        return res

    return wrap

# [题目1] 斐波那契数列（Fibonacci sequence）:
# F(0)=1，F(1)=1, F(n)=F(n-1)+F(n-2)（n>=2）
# 1, 1, 2, 3, 5, 8, 13, 21, 34, ...
# 求数列第n项的值？
@memo
def fibonacci(n):
    if n <= 1:
        return 1
    return fibonacci(n-1) + fibonacci(n-2)

# fibonacci = memo(fibonacci)
print(fibonacci(50))

# [题目2] 走楼梯问题
# 有100阶楼梯, 一个人每次可以迈1~3阶. 一共有多少走法？ 
@memo
def climb(n, steps):
    count = 0
    if n == 0:
        count = 1
    elif n > 0:
        for step in steps:
            count += climb(n-step, steps)
    return count

print(climb(100, (1,2,3)))


# dataclass装饰器
# 会自动生成构造函数
# 同时会重写__repr__方法输出更好的可读性
# init为False时就不会自动生成
# repr为False时就不会重写__repr__方法
from dataclasses import dataclass

@dataclass(init=False, repr=False)
class Student():
    name: str
    age: int
    school_name: str

student = Student('desmond', 18, 'CUHK')