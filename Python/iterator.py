# 自定義迭代器對象和可迭代對象
# 例子
from collections import Iterable, Iterator
import requests

# 定義迭代器類
class WeatherIterator(Iterator):
    def __init__(self, cities):
        self.cities = cities
        self.index = 0

    def __next__(self):
        if self.index == len(self.cities):
            raise StopIteration
        city = self.cities[self.index]
        self.index += 1
        return self.get_weather(city)

    def get_weather(self, city):
        url = 'http://wthrcdn.etouch.cn/weather_mini?city=' + city
        r = requests.get(url)
        data = r.json()['data']['forecase'][0]
        return city, data['high'], data['low']

# 定義可迭代類
class WeatherIterable(Iterable):
    def __init__(self, cities):
        self.cities = cities

    def __iter__(self):
        return WeatherIterator(self.cities)

def show(w):
    # 使用for時就會調用__iter__，然後一直循環到觸發StopIteration爲止
    for x in w:
        print(x)

w = WeatherIterable(['北京', '廈門'])
show(w)
# 這裏不直接使用Iteraror的原因是每次迭代都需要一個新對象
# 如果直接使用迭代器，那麼跑完一次就迭代完了
# 迭代器對象也是可迭代對象 isinstance

# 如果使用for循環時發現對象沒有實現迭代器
# 則python會自動幫我們去查找是否有__getitem__
# 有的話他就會一次一次去調用這個方法直到拋出異常



# 生成器對象也是迭代器對象 isinstance
# 生成器實現可迭代對象
from collections import Iterable
class PrimeNumbers(Iterable):
    def __init__(self, a, b):
        self.a = a
        self.b = b

    def __iter__(self):
        for k in range(self.a, self.b + 1):
            if self.is_prime(k):
                yield k
    
    def is_prime(self, k):
        return False if k < 2 else all(map(lambda x: k % x, range(2, k)))
        # if k < 2:
        #     return False
        # for x in range(2, k):
        #     if k % x == 0:
        #         return False
        # return True

pn = PrimeNumbers(1, 30)
for n in pn:
    print(n)



# 反向迭代
l = [1,2,3]
# reversed會生成一個反向迭代器對象與iter正好相反
# 前提是l必須實現__reversed__方法
for x in reversed(l):
    print(x)

# 例子
from decimal import Decimal

class FloatRange:
    def __init__(self, a, b, step):
        # 使用Decimal來消除python中float的誤差，但是切記要先轉換爲string，否則無效
        self.a = Decimal(str(a)) 
        self.b = Decimal(str(b)) 
        self.step = Decimal(str(step)) 

    def __iter__(self):
        t = self.a
        while t <= self.b:
            yield float(t)
            t += self.step

    def __reversed__(self):
        t = self.b
        while t >= self.a:
            yield float(t)
            t -=self.step

fr = FloatRange(3.0, 4.0, 0.2)

for x in fr:
    print(x)

for x in reversed(fr):
    print(x)



# 對於列表使用時的方括號, 其實背後調用的是__getitem__
# l[3] 等於 l.__getitem__(3)
# l[2:8] 等於 l.__getitem__(slice(2, 8))  
# slice會返回一個切片對象，第3個參數爲步進值，默認爲1
# 可迭代對象切片操作
# 例子
from itertools import islice
f = open('/var/log/test.log')
# 此時, 前100行也會被讀入
for line in islice(f, 100 - 1, 300):
    print(line)

# 自己實現一個類似islice的方法
def my_islice(iterable, start, end, step=1):
    tmp = 0
    for i, x in enumerate(iterable):
        if i >= end:
            break
    
        if i >= start:
            if tmp == 0:
                tmp = step
                yield x
            tmp -= 1



# for語句中迭代多個可迭代對象
# list(chain(*[['ooo', 123], ['ccc'], ['aaa', 'bbb']]))
from itertools import chain
arr1 = [80, 81, 100]
arr2 = [77, 99, 88]
arr3 = [88, 91, 93]
[x for x in chain(arr1, arr2, arr3) if x > 90]