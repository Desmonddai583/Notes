# 調用Thread方法
# t = Thread(target=method_name, args=()) 這裏即便沒有參數也要傳入一個空元組
# t.join(3) 會阻賽住當前線程等待子線程結束，傳入的參數代表最大等待時間，可以不傳入

import requests
import base64
from io import StringIO
import csv
from xml.etree.ElementTree import ElementTree, Element, SubElement

USERNAME = b'7f304a2df40829cd4f1b17d10cda0304'
PASSWORD = b'aff978c42479491f9541ace709081b99'

def download_csv(page_number):
    print('download csv data [page=%s]' % page_number)
    url = "http://api.intrinio.com/prices.csv?ticker=AAPL&hide_paging=true&page_size=200&page_number=%s" % page_number
    auth = b'Basic ' + base64.b64encode(b'%s:%s' % (USERNAME, PASSWORD))
    headers = {'Authorization' : auth}
    response = requests.get(url, headers=headers)

    if response.ok:
        return StringIO(response.text)

def csv_to_xml(csv_file, xml_path):
    print('Convert csv data to %s' % xml_path)
    reader = csv.reader(csv_file)
    headers = next(reader)

    root = Element('Data')
    root.text = '\n\t'
    root.tail = '\n'

    for row in reader:
        book = SubElement(root, 'Row')
        book.text = '\n\t\t'
        book.tail = '\n\t'

        for tag, text in zip(headers, row):
            e = SubElement(book, tag)
            e.text = text
            e.tail = '\n\t\t'
        e.tail = '\n\t'

    ElementTree(root).write(xml_path, encoding='utf8')

def download_and_save(page_number, xml_path):
    # IO
    csv_file = None
    while not csv_file:
        csv_file = download_csv(page_number)
    # CPU
    csv_to_xml(csv_file, 'data%s.xml' % page_number)

# 也可以通過創建一個繼承Thread的類來實現
# 必須要實現一個run方法
# 當對象調用start時會去調用這個run方法
from threading import Thread
class MyThread(Thread):
    def __init__(self, page_number, xml_path):
        super().__init__()
        self.page_number = page_number
        self.xml_path = xml_path

    def run(self):
        download_and_save(self.page_number, self.xml_path)

if __name__ == '__main__':
    import time
    t0 = time.time()
    thread_list = []
    for i in range(1, 6):
        t = MyThread(i, 'data%s.xml' % i)
        t.start()
        thread_list.append(t)

    for t in thread_list:
        t.join()
    # for i in range(1, 6):
    #      download_and_save(i, 'data%s.xml' % i)
    print(time.time() - t0)
    print('main thread end.')