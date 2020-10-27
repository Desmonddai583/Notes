# 查看对象的地址空间
id(object)
# 全局只有一个None对象
a = None
b = None
id(a) == id(b)



# __str__与__repr__的区别是
# __repr__是将对象转化为供解释器读取的形式，它的输出结果不仅有内容
# 还包括了对象的实例类型
# 所以它可以通过eval()重新变回一个Python对象，多适用于开发和调试



# 派生內置不可變類型並修改其實例化行爲
# 在創建對象是__init__之前其實會先讓類調用類方法__new__生成一個對象
# 接着再將該對象作爲__init__的第一個參數self傳入__init__
class A:
    def __new__(cls, *args):
        return object.__new__(cls)
    
    def __init__(self, *args):
        pass
# 例如像tuple類型，想要派生修改就需要在__new__中進行
# 因爲tuple初始化實在__new__中實現的



# 如何爲創建大量實例節省內存
# 對象中有一個__dict__屬性，用來支持對象的動態屬性設置
# 這個__dict__在一開始是沒有的，只有當我們開始復制對象屬性時才會產生
# 这里注意内建对象是不存在这个属性的，像list等
# p1.x = 100 等於 p1.__dict__['x'] = 100
# p1.__dict__.pop(x) 刪除屬性
# 這個字典就會佔用比較多的內存
# sys.getsizeof(p1.__dict__) 獲取內存佔用大小
# 如果要節省內存的話，可以通過__slots__
# 在類定義中使用__slots__ = ['uid', 'name', 'level']
# 這樣就會預先分配好屬性，並且之後不可以在動態添加

# 跟蹤內存使用
import tracemalloc
tracemalloc.start()
# start
# 跟蹤代碼
# end
snapshot = tracemalloc.take_snapshot()
# 按行數統計，也可以傳入filename，就是按文件統計
top_stats = snapshot.statistics('lineno')



# 如何讓對象支持上下文管理
# 下面是一個telnet登錄的例子
from sys import stdin, stdout
import getpass
import telnetlib
from collections import deque

class TelnetClient:
    def __init__(self, host, port=23):
        self.host = host
        self.port = port 

    def __enter__(self):
        self.tn = telnetlib.Telnet(self.host, self.port)
        self.history = deque([])
        return self

    # 異常類型，異常值，異常調用棧
    # 上下文中有異常也會調用該方法並傳入對應參數
    # 如果沒有異常則全爲None
    def __exit__(self, exc_type, exc_value, exc_tb):
        print('IN __exit__', exc_type, exc_value, exc_tb)

        self.tn.close()
        self.tn = None

        with open('history.txt', 'a') as f:
            f.writelines(self.history)

        # 如果返回給一個真值，則異常觸發時不會拋到上一層
        return True

    def login(self):
        # user
        self.tn.read_until(b"login: ")
        user = input("Enter your remote account: ")
        self.tn.write(user.encode('utf8') + b"\n")

        # password
        self.tn.read_until(b"Password: ")
        password = getpass.getpass()
        self.tn.write(password.encode('utf8') + b"\n")
        out = self.tn.read_until(b'$ ')
        stdout.write(out.decode('utf8'))

    def interact(self):
        while True:
            cmd = stdin.readline()
            if not cmd:
                break

            self.history.append(cmd)
            self.tn.write(cmd.encode('utf8'))
            out = self.tn.read_until(b'$ ').decode('utf8')

            stdout.write(out[len(cmd)+1:])
            stdout.flush()

# with背後其實就是調用一個__enter__方法返回一個對象作爲as後面的變量
# 所以實現__enter__即可支持對象的上下文管理
# 離開上下文的時候就會調用__exit__方法
with TelnetClient('192.168.0.105') as client:
    raise Exception('TEST')
    client.login()
    client.interact()

print('END')

# python中可以使用contextlib模块来简化上下文管理
import contextlib
# yield之前的代码就等同于__enter__里面的逻辑
# yield之后的代码就等同于__exit__里面的逻辑
@contextlib.contextmanager
def file_open(file_name):
    print("file open")
    yield {}
    print("file end")

with file_open("bobby.txt") as f_opened:
    print("file processing")



# 創建可管理的對象屬性
# 加了property後就可以像調用屬性一樣調用get,set等方法
import math

class Circle:
    def __init__(self, radius):
        self.radius = radius

    def get_radius(self):
        return round(self.radius, 1)

    def set_radius(self, radius):
        if not isinstance(radius, (int, float)):
            raise TypeError('wronge type')
        self.radius = radius

    
    @property
    def S(self):
        return self.radius ** 2 * math.pi

    @S.setter
    def S(self, s):
        self.radius = math.sqrt(s / math.pi)

    # property裏面可以一次放入get，set，del，doc方法
    R = property(get_radius, set_radius)

c = Circle(5.712)

c.S = 99.88
print(c.S)
print(c.R)



# 讓類支持比較操作
# 實現__lt__和__eq__等方法即可支持比較
# 假設實現了__lt__方法，但是調用時使用>, python依舊會調用__lt__，但是會將兩個對象調轉
from functools import total_ordering

from abc import ABCMeta, abstractclassmethod

# 使用total_ordering只需要實現lt和eq即可，背後會自動幫忙去處理其他情況(例如小於等於，大於等於等)
# 背後其實就是幫我們實現了那些le,gt等方法，裏面就用我們自己寫的lt和eq去組合判斷
# 這裏通過一個公共抽象基類來實現不同類間的比較
# 抽象基类是不可以实例化的
@total_ordering
class Shape(metaclass=ABCMeta):
    # 這裏通過裝飾器定義了一個抽象方法，那麼繼承這個類的所有類都必須實現這個方法
    @abstractclassmethod
    def area(self):
        pass

    def __lt__(self, obj):
        print('__lt__', self, obj)
        return self.area() < obj.area()

    def __eq__(self, obj):
        return self.area() == obj.area()

class Rect(Shape):
    def __init__(self, w, h):
        self.w = w
        self.h = h

    def area(self):
        return self.w * self.h

    def __str__(self):
        return 'Rect:(%s, %s)' % (self.w, self.h)

import math
class Circle(Shape):
    def __init__(self, r):
        self.r = r

    def area(self):
        return self.r ** 2 * math.pi


rect1 = Rect(6, 9) # 54
rect2 = Rect(7, 8) # 56
c = Circle(8)

print(rect1 < c)
print(c > rect2)



# 抽象基类中有一些预设的类型
from collections.abc import Sized
# 像Sized类即便我们实现的类没有继承它，但是只要实现了__len__类
# isinstance都会返回True，因为Size类背后实现了一个__subclasshook__方法
# 调用isinstance方法时就会调用该方法，只要类中有实现__len__就会返回True
# 除此之外isinstance还可以通过继承链去判断真假



# 最新的Python中类和实例的属性查找方法使用的是一种叫做C3的算法
# 背后的原理比较复杂，可以通过__mro__获取查找链



# 使用描述符對實例屬性做類型檢查
# 只要一個類包含了set，get，delete其中之一就可以稱之爲一個描述符
class Attr:
    def __init__(self, key, type_):
        self.key = key
        self.type_ = type_

    def __set__(self, instance, value):
        print('in __set__')
        if not isinstance(value, self.type_):
            raise TypeError('must be %s' % self.type_)
        instance.__dict__[self.key] = value

    def __get__(self, instance, cls):
        print('in __get__', instance, cls)
        return instance.__dict__[self.key]

    def __delete__(self, instance):
        print('in __del__', instance)
        del instance.__dict__[self.key]

class Person:
    # 定義好類屬性，當對象調用這些屬性時就會被對應的描述符捕獲
    name = Attr('name', str)
    age = Attr('age', int)

p = Person()
p.name = 'liushuo'
p.age = '32'
del p.age



# 環狀數據結構中管理內存
# 下面這個例子中如果不使用弱引用，就會出現循環引用的情況
# __del__只有在引用計數爲0時才會被調用
# 使用弱引用就不會增加引用計數
import weakref
class Node:
    def __init__(self, data):
        self.data = data
        self._left = None
        self.right = None

    def add_right(self, node):
        self.right = node
        # 這裏如果使用node._left()就會獲取到原來self的應用
        # 如果引用計數爲0時，那麼node._left()就返回None
        node._left = weakref.ref(self)

    @property
    def left(self):
        return self._left()

    def __str__(self):
        return 'Node:<%s>' % self.data

    def __del__(self):
        print('in __del__: delete %s' % self)

def create_linklist(n):
    head = current = Node(1)
    for i in range(2, n + 1):
        node = Node(i)
        current.add_right(node)
        current = node
    return head

head = create_linklist(1000)
print(head.right, head.right.left)
input()
head = None

import time
for _ in range(1000):
    time.sleep(1)
    print('run...')
input('wait...')



# 通過實例方法名字的字符串調用方法
# 下面的例子中，每個類都有自己都方法來獲取面積
# 我們通過元編程來實現一個方法，他會根據不同的類對象來調用對應的方法獲取面積
# getattr(s, 'find', None) 用來獲取對象的實例方法，第三個參數代表找不到時返回的默認值
from lib1 import Circle
from lib2 import Triangle
from lib3 import Rectangle
from operator import methodcaller

def get_area(shape, method_name = ['area', 'get_area', 'getArea']):
    for name in method_name:
        if hasattr(shape, name):
            # methodcaller是先傳入方法與參數，再將返回的methodcaller對象調用執行的對象
            return methodcaller(name)(shape)
        # f = getattr(shape, name, None)
        # if f:
        #     return f()


shape1 = Circle(1)
shape2 = Triangle(3, 4, 5)
shape3 = Rectangle(4, 6)

shape_list = [shape1, shape2, shape3]
# 获得面积列表
area_list = list(map(get_area, shape_list))
print(area_list)



# python中的mixin特点
# python中尽量少使用多继承用mixin来替代
# 类似于ruby中的module
# mixin其实背后也是一个类
# 1. 功能单一
# 2. 不和基类关联，可以和任意基类组合， 基类可以不和mixin关联就能初始化成功
# 3. 在mixin中不要使用super这种用法