# 處理cpu密集型任務就需要使用多進程
# Process生成對象，調用start和join都跟thread類似
# 進程與線程區別在於，對於地址空間，進程會fork出一個新的地址空間
# 每個進程都有自己獨立的地址空間

from threading import Thread
from multiprocessing import Process
from queue import Queue as Thread_Queue 
# 進程的queue與線程的queue不同之處在與
# 線程的queue是在地址空間內的，因爲同一個進程下的線程公用一個地址空間
# 但是進程的queue是存在於操作系統的pipe中，不屬於某個進程的地址空間
# Pipe的使用
# from multiprocessing import Pipe
# c1, c2 = Pipe()
# def f(c):
#     data = c.recv()
#     c.send(data * 2)
# Process(target=f, args=(c2,)).start()
# c1.send(100)
# c1.recv()

from multiprocessing import Queue as Process_Queue

def is_armstrong(n):
    a, t = [], n
    while t:
        a.append(t % 10)
        t //= 10
    k = len(a)
    return sum(x ** k for x in a) == n

def find_armstrong(a, b, q=None):
    res = [x for x in range(a, b) if is_armstrong(x)]
    if q:
        q.put(res)
    return res

def find_by_thread(*ranges):
    q = Thread_Queue()
    workers = []
    for r in ranges:
        a, b = r
        t = Thread(target=find_armstrong, args=(a, b, q))
        t.start()
        workers.append(t)

    res = []
    for _ in range(len(ranges)):
        res.extend(q.get())

    return res

def find_by_process(*ranges):
    q = Process_Queue()
    workers = []
    for r in ranges:
        a, b = r
        t = Process(target=find_armstrong, args=(a, b, q))
        t.start()
        workers.append(t)

    res = []
    for _ in range(len(ranges)):
        res.extend(q.get())

    return res

if __name__ == '__main__':
    import time
    t0 = time.time()
    res = find_by_thread([10000000, 15000000], [15000000, 20000000], 
                         [20000000, 25000000], [25000000, 30000000])
    print(res)
    print(time.time() - t0)