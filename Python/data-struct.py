# 爲元組命名, 使用元組節省內存空間
from collections import nametuple
Student = nametuple('Student', ['name', 'age', 'sex', 'email']) # 創建了一個命名元組類
s = Student('Jim', 16, 'male', 'jim8721@gmail.com') # s是一個元組
isinstance(s, tuple) # True
s.name
s.age



# 字典值排序
# 1.1. 轉換爲元組排序
from random import randint
d = {k: randint(60, 100) for k in 'abcdefgh'}
l = [(v, k) for k, v in d.items()]
sorted(l， reverse= True)

# 1.2. zip, 背後都是轉換成元組排序
list(zip(d.values, d.keys()))

# 2. 直接利用sorted的key參數
p =sorted(d.items(), key=lambda item: item[1], reverse=True)

# 將結果賦予次序
for i, (k, v) enumerate(p, 1): # 返回一個enumerate對象，第二個參數代表起始值
    d[k] = (i, v)
# {'h': (1, 99), 'g': (5, 98).....}
# 也可以生成一個新字典
{k: (i, v) for i, (k, v) in enumerate(p, 1)}


# 統計序列中元素頻率
# 1. 先轉爲頻度字典，在使用字典排序
from random import randint
data = [randint(0, 20) for _ in range(30)]
d = dict.fromkeys(data, 0) # 根據列表創建字典，列表中的值會變成字典的鍵，初值爲0
for x in data:
    d[x] += 1

import heapq # 使用heap可以不需要排序整個列表
heapq.nlargest(3, ((v, k) for k, v in d.items()))

# 2. 使用Counter類
from collections import Counter
c = Counter(data)
c.most_common(3)



# n個字典中的公共鍵
from random import randint, sample
d1 = {k: randint(1, 4) for k in sample('abcdefgh', randint(3, 6))}
d2 = {k: randint(1, 4) for k in sample('abcdefgh', randint(3, 6))}
d3 = {k: randint(1, 4) for k in sample('abcdefgh', randint(3, 6))}
# 1. 判斷第一個中的每個鍵是否都在其他中出現
dl = [d1, d2, d3]
[k for k in dl[0] if all(map(lambda d: k in d, dl[1:]))]

# 2. 利用集合交集操作
reduce(lambda a, b): a & b, map(dict.keys, dl))



# 讓字典保持有序
# 1. 使用OrderedDict, 此時的key就是有序的了
from collections import OrderedDict
players = list('abcdefgh')
from random import shuffle
shuffle(players)
od = OrderedDict()
for i, p in enumerate(players, 1):
    od[p] = i

def quert_by_name(d, name):
    return d[name]

from itertools import islice
def query_by_order(d, start, end=None): 
    start -= 1
    if end is None:
        end = start + 1
    return list(islice(od, a, b))
# 這裏注意在3.6中內置字典已經是OrderedDict了



# 實現歷史記錄功能
from collections import deque
q = deque([], 5) # 創建一個兩端隊列，兩端都可以入隊和出對，第二個參數爲隊列最大長度，超過會擠掉原來的
q.append(1)
q.appendleft(2)
# 使用pickle模塊可以把python中的對象存儲到磁盤中
import pickle
pickle.dump(q, open('save.pkl', 'wb')) # pickle模塊中文件對象一定要使用2進制打開
content = pickle.load(open('save.pkl', 'rb'))