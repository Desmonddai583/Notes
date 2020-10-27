# regex拆分字符串
# 1
def my_split(s, seps):
    res = [s]
    for sep in seps:
        t = []
        list(map(lambda ss: t.extend(ss.split(sep)), res))
        res = t
    return res

# 2
from functools import reduce
my_split2 = lambda s, seps: reduce(lambda l, sep: sum(map(lambda ss: ss.split(sep), l), []), seps, [s])

# 3
from itertools import chain
reduce(lambda it_s, sep: chain(*map(lambda ss: ss.split(sep), it_s)), ':|\t', [s])

# 4 這裏注意處理單個分隔符還是直接使用string自帶的split比較快
import re
re.split('[:,|\t]+', "123|123,456")




# 判斷字符串a是否以字符串b開頭或結尾
# 例子, 將.py或.sh結尾的文件轉爲可執行的
import os
import stat

for fn in os.listdir():
    # endswith或startswith如果需要多個匹配時可以使用元組
    if fn.endswith(('.py', '.sh')):
        fs = os.stat(fn)
        os.chmod(fn, fs.st_mode | stat.S_IXUSR)



# 調整字符串中文本的格式
# 例子, 將yyyy-mm-dd替換成mm/dd/yyyy
import re
# 括號用來表示組，替換時按照字母順序，
# 如果有括號嵌套的情況，前面數字先表示外面的括號
log = "2019-03-04 adsfsdfasfsa"
# 這裏記得替換是加r，代表raw
# 這樣python會直接當成\2輸出，而不會將它轉換成八進制數
# 例如 
# ord('a') 97
# oct(ord('a')) '0o141'
# '\141' a
# 如果不是用r的話那麼就需要使用'\\2'
re.sub('(\d{4})-(\d{2})-(\d{2})', r'\2/\3/\1', log)
# 如果組太多想使用別名可以通過
re.sub(r'(?P<d>\d{4})-(?P<m>\d{2})-(?P<y>\d{2})', r'\g<m>/\g<d>/\g<y>', log)



# 拼接字符串
# 正常使用for循環等方法在時間與空間上都有浪費
# 推薦使用join方法
':'.join(['abc', '123', '456'])



# 對字符串進行左右中對齊
s = 'abc'
# 1
# 左對齊10爲不夠用第二個參數定義的字符串補(默認爲space),該補位字符串只可包含一個字符
# 小於原本的長度則不做處理，直接使用原本字符串
s.ljust(10, '^') 
s.rjust(10, '^') 
s.center(10, '^')

# 2
format(s, '<10') # 左
format(s, '>10') # 右
format(s, '^10') # 居中
format(s, '*^10') # 居中並填充*
# format也可以傳入數字等, 只要對象的類實現了__format__方法即可使用
# 關於數字
format(123, '+') # '123'
format(-123, '+') # '-123'
format(-123, '>+10') # 輸出符號並且右對齊
format(-123, '=+10') # 輸出符號並且右對齊，但是符號會放在最左邊
# 輸出符號並且右對齊，但是符號會放在最左邊，中間缺的爲用0補齊
format(-123, '0=+10') 



# 去掉字符串中不需要的字符
s.strip() # 去掉兩端的space或者\t
s.strip('=+-') # 去掉兩端=, +, -等字符
# 或者使用string的replace方法以及re.sub方法
# translate
# 這裏字典的key一定要是ASCII碼
s.translate({ord('a'): 'X', ord('b'): 'Y'})
# maketrans 可以用來獲取映射字典
s.translate(s.maketrans('abcxyz', 'XYZABC'))
s.translate({ord('a'): None}) # 這裏利用translate去除字符串中的a

# 例子, 去掉有拼音的字母
s = 'nĭ hăo'
import unicodedata
# combining用來判斷是不是一個和combine字符, 如果是正常字符則返回0
# dict.fromkeys會根據第一個參數的元素爲字典的key創建字典，第二個參數爲默認的value, 不指定默認爲None
s.translate(dict.fromkeys([ord(c) for c in s if unicodedata.combining(c)]))


# f关键字拼接
b = 'desmond'
f'this is {b}'