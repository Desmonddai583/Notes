2/2 # 结果为float型
2//2 # 结果为int型
bin(10) # 将数字转2进制
oct(10) # 转8进制
hex(10) # 转16进制
ord('w') # 获取字符ASCII码

bool('') # 空字符串，空列表，空字典，0，None等返回False

r'c:\n123' # 会输出原始字符转，不会解释转义字符
aa = 'test'
aa = u'test'  # 轉爲unicode類型

# tuple不可變，存取時tuple和字典都快於列表

#set是无序的，无法用下标取值
{1,2,3} - {2,3} # 取集合差值
{1,2,3} & {2,3} # 取交集
{1,2,3} | {2,3,4} # 取并集

# is比较两个变量内存地址是否相同
# isinstance(a, int)判断变量类型
# isinstance可以多个类型筛选 e.g. isinstance(a, (int, str, float))

# for..else 如果有break则else不会触发

# a[0:10:2]去a的0到9下表, 步数为2
# 不該變原有列表的情況下反序
l = [1,2,3]
l2 = l[::-1]

# 使用range賦值
a, b, c, d = range(4)

# 模块定义时, 可以通过__all__ = ['a', 'c'] 来指定只导出a变量和c变量
# dir()获取模块内置变量名，不传参默认为当前模块，对于入口文件__package__为None，__name__为__main__，__file__只是根据调用时路径决定
# python -m 可以将执行文件当成模块然运行，e.g python -m severn.c15，此时__package__会变成seven，但是__name__还是__main__
# from import的方式可以使用相对导入，e.g. from .m3 import m, 这里.代表当前路径，..代表上一级路径，每加一个点多一层。
# 注意入口文件不可以使用相对导入，如果想要做到的话就需要用python -m来实现

# sys.setrecursionlimit(1000)设定递归的最多次数

# 关键字参数 e.g. def add(x, y),  add(y=3, x=4)
# 可变参数 e.g. def demo(*param), demo(1,2,3,4) 或者 a = (1,2,3,4) demo(*a)
# 关键字可变参数 e.g. def demo(**param), demo(a='123', b='566') 或者 a = {'a':'32', 'b':'dd'} demo(**a)

# global c; c = 2 可以将局部变量变成全局变量
# nonlocal c 将变量声明为非本地变量

# 变量可以通过__dict__来获取它的属性和方法
# 在python中，使用对象来访问类变量会自动fallback回类中去寻找
# 实例方法中调用类变量可以通过Student.count或者self.__class__.count

# 通过装饰器@classmethod来定义类方法 e.g.
# @classmethod
# def test(cls):
# python中是可以用对象来调用类方法的，但是不建议使用

# 通过装饰器@staticmethod来定义静态方法
# 不需要像类方法或者实例方法一样默认传入一个像self或者cls的参数

# 变量或方法前面加__就会变为私有的
# 但如果结尾使用__的话python就不会当为私有的
# 类中定义私有变量之后其实变量名会变成类似_Student__score
# 所以在外部也还是可以根据这个规范来读写私有变量的

# python中的类是可以多继承的
# 子类中调用父类构造方法可以使用super(Student, self).init(name, age)
# python3中如果只有一个父类可以直接使用super().init(name, age)
# 子类中调用父类的实例方法也可以使用super的方式来调用
# super背后的调用顺序也是根据mro来执行

# json.loads(json_str) json反序列化
# json.dumps(dict) json序列化

# 创建一个枚举类, python中的枚举其实就是一个类
# class VIP(Enum):
#     YELLOW = 1
#     BLUE = 2
# 使用时print(VIP.YELLOW)或者print(VIP['YELLOW']), 返回的是VIP.YELLOW，背后类型是一个枚举类型
# 获取值则使用VIP.YELLOW.value
# 获取枚举名称则使用VIP.YELLOW.name，背后是一个string
# 枚举类与一般类的区别就是里面的类变量是不可变的，并且能防重复值问题
# for v in VIP 枚举是可以遍历的，返回的是每一个枚举类型
# 枚举类型不支持大小的比较操作
# 如果存在两个值相等的枚举名称，那么后面那个其实可以看成是前面一个枚举类型的别名，遍历时也不会把后面那个算进去
# 如果包括别名也想要在遍历时算进去的话，可以使用VIP.__members__.items()
# 将枚举值转为枚举类型可以使用VIP(1)
# 如果要强制枚举值为整型，可以继承IntEnum
# 如果希望不会出现重复的枚举值，可以使用@unique装饰器

# 通过__closure__可以获取闭包的环境变量, e.g.
# f.__closure__[0].cell_contents

# 將列表轉換位迭代器
iter([1, 2, 3]) # 此時該對象就可以通過next方法調用

# 在一个类中实现了__iter__和__next__，这个类就会变成一个迭代器
class BookCollection:
    def __init__(self):
        self.data = [1,2,3]
        self.cur = 0
        pass
    
    def __iter__(self):
        return self
    
    def __next__(self):
        if self.cur > len(self.data):
            raise StopIteration() # 内置的迭代错误异常
        r = self.data[self.cur]
        self.cur += 1
        return r
# 迭代器遍历一次之后就不能再遍历了，如果想要在遍历的话除了重新生成一个对象
# 还可以使用copy方法
books = BookCollection()
import copy
books_copy = copy.copy(books) # 深拷贝请使用deepcopy

# 生成器
def odd():
    print('step 1')
    yield 1
    print('step 2')
    yield(3)
    print('step 3')
    yield(5)

o = odd()
next(o) # 1
next(o) # 3
next(o) # 5
next(o) # 報錯

# 生成器表達式
( item + 2 for item in aa ) # 返回一個生成器，可以通過next調用

# 一个对象是否为True是根据__bool__与__len__返回值决定的，默认不定义这两个方法对象返回True
# 两个方法都定义时，只会调用__bool__方法来判断，__len__不会被调用
# 对象调用len背后就是调用__len__,默认不定义的话调用len会报错

# 列表解析
aa = [1, 2, 3]
[ item + 2 for item in aa if item < 3 ] # [3, 4]
aa = {1, 2, 3}
{ item + 2 for item in aa if item < 3 } # 大括號返回的是set
# 字典也可以解析
b = [key for key, value in student_dict.items()]

# lambda定義匿名函數
# lambda只能放表达式，不能放代码块
a = lambda x, y: x + y
a(20, 40)

# python中的三元表达式, e.g.
# a = x if x > y else y

# map用法 map(func, list)或者map(lambda, list)
# map可以用于多组list, map(lambda x, y: x + y, list_x, list_y)
# map背后其实是一个类，所以返回的是一个map对象

# reduce用法 reduce(lambda x, y: x + y, list, 10) 最后一个参数为初始值
# reduce背后是一个函数

# filter用法 reduce(lambda x: x > 10, list)
# filter背后其实是一个类，所以返回的是一个filter对象

# Regex
# {N}                  匹配前面出现的正则表达式N次    [0-9]{3}
# {M,N}                匹配重复出现M次到N次正则表达式 [0-9]{5,9} 
# re1|re2              匹配正则表达式re1或re2 
# \bthe                任何以"the"开始的字符串
# \bthe\b              仅匹配单词"the"
# \Bthe                任意包含"the"但不以"the"开头的单词
# b[aeiu]t             bat, bet, bit, but
# [cr][23][dp][o2]     一个包含 4 个字符的字符串: 第一个字符是“r”或“c”,后面是“2”或 “3”,再接下来是 “d” 或 “p”,最后是 “o” 或 “2“ ,例 如:c2do, r3p2, r2d2, c3po, 等等。 
# [r-u][env-y][us]     “r”“s,”“t” 或 “u” 中的任意一个字符,后面跟的是 “e,” “n,” “v,” “w,” “x,” 或 “y”中的任意一个字符,再后面 是字符“u” 或 “s”. 
# [^aeiou]             一个非元音字符 
# [^\t\n]              除 TAB 制表符和换行符以外的任意一个字符 
# \w+@\w+\.com         简单的 XXX@YYY.com 格式的电子邮件地址 
# \d+(\.\d*)?          浮点数 匹配：0.004,”“2.”“75.”
# python中正则默认为贪婪模式， e.g. [0-9]{5,9}会贪婪匹配最多到9，如果要转为非贪婪，则使用[0-9]{5,9}?

import re
# from re import search as ss  導入模塊的某個方法並取別名
re.search("a.c", "123abcyul") # 返回第一个匹配的对象
r = re.match("(a.c)", "123abcyul") # match會從頭開始匹配,只要前面不匹配就會返回空
r.groups() # 返回匹配的內容, 是一個元組
r.group(0) # 返回原字符串
r.group(1) # 返回第一個匹配
r.group(0,1,2) # 一次返回多个匹配
# re.findall('正则表达式', 字符串)  查找匹配到的正则字符串，返回列表
# re.findall('正则表达式', 字符串, re.I | re.S)  re.I代表忽略大小写, re.S代表.可以代表包括\n在内的所有字符，默认是不包括\n的
# re.sub('正则表达式', 替换的字串, 原字串, 0)  0代表匹配所有
# 替换的字串也可以改为一个函数 e.g.
# def covert(value): 返回值将作为替换的字串
#     return "!!" + value.group()  value是一个对象
# re.sub('正则表达式', convert, 原字串, 0) 

# 裝飾器
# 加了装饰器之后，函数名会变成wrapper
# 解决的方法是
# from functools import wraps
def use_logging(func):
    # @wraps(func)
    def wrapper(*args, **kwargs):
        print("%s is running" % func.__name__)
        return func(*args)
    return wrapper

@use_logging
def foo():
    print("i am foo")

foo()

# 使用字典實現switch
day = 6
switcher = {
    0: 'Sunday',
    1: 'Monday',
    2: 'Tuesday'
}
day_name = switcher.get(day, 'none') # 第二個參數爲默認值
# 字典中的value也可以是函數

# 函數annotation
# 這個只是幫助使用者了解的，並不會真正做校驗
def f(a: int, b: int) -> int:
    pass
f.__annotations__

# 通過__defaults__可以查看默認參數值
# 但是從這裏也可以看出默認參數不要去傳可變對象
# 否則一旦在函數內部修改了之後，在下一次調用時，默認參數就會被改變了
def f(a, b=1, c=[]):
    pass

f.__defaults__

# 海象运算符
# 避免函数重复执行,也可以免去定义
if (b:= len(a)) > 5:
    str(b)