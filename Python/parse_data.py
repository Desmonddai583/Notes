# 讀寫csv
import csv
rf = open('books.csv')
# 默認delimiter爲逗號，所以可以不寫
reader = csv.reader(rf, delimiter=',')
next(reader)

wf = csv.writer('demo.csv', 'w')
writer = csv.writer(wf, delimiter=' ')
writer.writerow(['x', 'y', 'z'])
writer.writerow([1, 2, 3])
wf.flush()



# 讀寫json
# import json
# d = json.loads(json_str)
# json_str = json.dumps(d)
# json和dump方法放入的是文件
# 例子
# f = open('demo.json', 'w')
# json.dump(data, f)
# f.close()
# f2 = open('demo.json')
# json.load(f2)



# 解析簡單的xml
from xml.etree import ElementTree
et = ElementTree.parse('demo.xml')
# 從字符串中解析
# ElementTree.fromstring(xml_str)
# 獲取根元素
root = et.getroot()
root.tag
root.attrib
# 獲取子元素
c = list(root)
c1 = c[0]
c1.get('name')
# 獲取文本內容，元素到它的下一個子元素之間的文本內容
c1.text
# 獲取element尾部結束之後到下一個元素之間的文本內容
c1.tail
# 查找子元素
c1.find('neighbor')
# 查找所有符合的子元素
c1.findall('neighbor')
# 上面兩個查找都只能查找自己下一層的子元素
# 使用iter就可以查到自己下面每一層的元素，返回一個迭代器對象
list(c1.iter('year'))
# iter如果不傳參數默認返回該元素下面的所有元素
# 通過xpath查找
list(c1.iterfind('./*/*[@name]'))
# 獲取元素下所有文本
c1.itertext()
# string.isspace() 判斷是否字符串爲space



# 構建xml文檔
import xml.etree.ElementTree as ET
data = ET.Element('Data')
book = ET.Element('Book')
author = ET.Element('Author')
# 設置屬性
book.set('x', 'abc')
# 設置文本內容
author.text = 'Desmond'
data.append(book)
book.append(author)
# 查看xml形式
ET.dump(data)

# 也可以通過SubElement直接加子節點
data = ET.Element('Data')
book = ET.SubElement(data, 'Book')
book.set('x', 'abc')

# 創建ElementTree對象並寫入文件
et = ET.ElementTree(data)
et.write('test.xml', encoding='utf8')



# 讀寫excel
import xlrd
book = xlrd.open_workbook('demo.xlsx')
# 返回所有的sheet，一個excel中可以開多個sheet
book.sheets()
# 獲取第一個sheet
sheet = book.sheet_by_index(0)
sheet.name
# 獲取總行列數
sheet.nrows
sheet.ncols
# 獲取0,0的cell對象
c00 = sheet.cell(0, 0)
c00.ctype
c00.value
# 直接獲取cell數據
sheet.cell_value(0, 0)
# 獲取行中的cell對象
sheet.row(0)
# 獲取行中的value
sheet.row_values(0)
# 獲取第一行並且第一列之後的數據
sheet.row_values(1, 1)
# 添加一個cell，最後一個參數代表如何format cell
sheet.put_cell(0, sheet.ncols, xlrd.XL_CELL_TEXT, '總分', None)

import xlwt
wbook = xlwt.Workbook()
wsheet = wbook.add_sheet('test')
wsheet.write(0, 0, 'abc')
wbook.save('test.xlsx')