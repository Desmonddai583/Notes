# python2中的str在python3中變成bytes
# python2中的unicode在python3中變成str

# python3讀寫文件
# 這裏s默認就是unicode了
s = '哈哈哈'
# 不傳encoding默認使用系統的
# t也可以不寫，默認就會用這種文本形式打開
f = open('a.txt', 'wt', encoding='utf8') 
f.write(s)
f.flush()

# rt都是默認的，所以可以都不加
f = open('a.txt', 'rt', encoding='utf8')
f.read()



# 處理二進制文件
# 二進制記得加b
f = open('demo.wav', 'rb')
# 讀入44個字節
info = f.read(44)
# 使用struct.unpack解析二進制數據
import struct
# h代表short整形
struct.unpack('h', info[22:24])
# 例子
# \x02\x00 
# \x02爲第一個字符去解析(\x00\x02)所以爲2
# 如果是>h則\x02作爲第二個字符去解析(\x02\x00)所以爲512

# 將文件指針指向開頭
f.seek(0)
# 這裏1代表當前位置，從當前位置向前移動3個位置
# 0是文件頭，2是文件尾
chunk_size = 3
f.seek(chunk_size, 1)
# 獲取當前指針位置
f.tell()
# 查詢2進制字符，這裏前面記得加b
info.find(b'data')

import numpy as np
size = 100
# 創建一個全0數組，類型爲short整形，除以2是因爲前面採樣是兩位的
buf = np.zeros(size // 2, dtype=np.short)
# 把剩下的數據讀入buffer中
f.readinto(buf)

f2 = open('out.wav', 'wb')
# 講buf寫入文件
buf.tofile(f2)
f2.close()



# 設置文件中的緩衝
# 1 全緩衝 只有當緩衝區寫滿之後才會觸發系統調用寫入硬盤
f = open('a.bin', 'wb')
f.write()
# dmesg | grep block 查看系統塊大小
# 默認會使用這個，如果找不到python就回去io模塊中查看設定的DEFAULT_BUFFER_SIZE
# io.DEFAULT_BUFFER_SIZE
# 對於文本模式打開的話，其實f背後是三層模型
# 第一層是TextIO，第二層是Buffer，第三層是Raw
# 第一層的緩衝默認爲8192，只有第一層寫滿才會觸發
# 所以對於文本來說即便buffer層大小是4096，但是都要等寫完8192才會觸發
# 而對於二進制打開文件就只有Buffer和Raw層
# raw層的話會直接跳過緩衝區
# 所以可以直接f.raw.write('123')
# 這樣就會直接寫入硬盤
# 另外一種方法就是講buffering設定爲0

# 2 行緩衝 遇到換行就會寫入硬盤，如果一直沒遇到那麼就跟全緩衝一樣滿了才觸發
# 行緩衝只能在文本模式使用
# 默認tty文件就是行緩衝的
f3 = open('/dev/pts/2', 'w')
# 判斷是否爲tty文件
f3.isatty()
# 加入buffering=1即可將一個文本模式打開的文件變成行緩衝模式

# 3 手動指定緩衝行爲
f = open('a.bin', 'wb', buffering=8192)
# 文本模式下指定buffering也是指定buffer那層的



# 將文件映射到內存 方便我們通過數組訪問
# dd if=/dev/zero of=demo.bin bs=1024 count=1024
# od -x demo.bin 以16進制形式查看二進制文件
# fbset 查看framebuffer屬性 
import mmap
f = open('demo.bin', 'r+b')
f.fileno() # 獲取文件描述符
# 指定length爲0則整個文件都會映射
m = mmap.mmap(f.fileno(), 0)
m.write(b'abc')
m[0]
m[5] = 78
m[8:16] = b'\xff' * 8



# 訪問文件的狀態
import os
s = os.stat('a.txt') # stat也可以傳入文件描述符
fd = os.open('b.py', os.O_RDONLY) # 獲取文件描述符
os.read(fd, 10) # 讀取10個字節
# 硬鏈接與軟鏈接區別
# 硬鏈接背後的數據就是源指向的數據
# 而軟鏈接背後的數據是一個路徑，也就是源的路徑
# 默認鏈接調用stat返回的是背後對應的源，可以通過設定follow_symlinks來取消
os.stat('link.txt', follow_symlinks=False)
# 或者
os.lstat('link.txt')

import stat
# 通過stat模塊想的一些mode作與操作來判斷文件屬性
stat.S_IFDIR & s.st_mode
stat.S_IFCHR & s.st_mode
# 或者直接當參數傳入判斷True或者False
stat.S_ISREG(s.st_mode)
# 獲取時間struct
import time
time.localtime(s.st_atime)

# 判斷文件類型和時間，大小
os.path.isdir('d')
os.path.isfile('a.txt')
os.path.getatime('a.txt')
os.path.getsize('a.txt')



# 使用臨時文件
# 好處是不用命名，關閉後就會被刪除
from tempfile import TemporaryFile, NamedTemporaryFile
tf = TemporaryFile()
tf.write(b'*' * 1024 * 1024)
tf.seek(0)
tf.read(512)
tf.close()
# TemporaryFile背後就是調用系統的open然後指定爲臨時文件
# NamedTemporaryFile則是python庫封裝的
# 背後是會在硬盤上開一個臨時文件，關閉時再刪除它
ntf = NamedTemporaryFile()
# 獲取路徑
ntf.name

# 獲取默認設定的帶名字的臨時文件目錄和前綴
import tempfile
tempfile.gettempdir()
tempfile.gettempprefix()

# 設置delete爲False則在關閉時不會刪除
ntf = NamedTemporaryFile(delete=False)