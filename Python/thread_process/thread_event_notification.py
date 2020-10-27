import requests
import base64
from io import StringIO
import csv
from xml.etree.ElementTree import ElementTree, Element, SubElement
from threading import Thread
from queue import Queue
import tarfile
import os

USERNAME = b'7f304a2df40829cd4f1b17d10cda0304'
PASSWORD = b'aff978c42479491f9541ace709081b99'

class DownloadThread(Thread):
    def __init__(self, page_number, queue):
        super().__init__()
        self.page_number = page_number
        self.queue = queue

    def run(self):
        csv_file = None
        while not csv_file:
            csv_file = self.download_csv(self.page_number)
        self.queue.put((self.page_number, csv_file))

    def download_csv(self, page_number):
        print('download csv data [page=%s]' % page_number)
        url = "http://api.intrinio.com/prices.csv?ticker=AAPL&hide_paging=true&page_size=100&page_number=%s" % page_number
        auth = b'Basic ' + base64.b64encode(b'%s:%s' % (USERNAME, PASSWORD))
        headers = {'Authorization' : auth}
        response = requests.get(url, headers=headers)

        if response.ok:
            return StringIO(response.text)

class ConvertThread(Thread):
    def __init__(self, queue, c_event, t_event):
        super().__init__()
        self.queue = queue
        self.c_event = c_event
        self.t_event = t_event

    def run(self):
        count = 0
        while True:
            page_number, csv_file = self.queue.get()
            if page_number == -1:
                self.c_event.set()
                self.t_event.wait()
                break

            self.csv_to_xml(csv_file, 'data%s.xml' % page_number)
            count += 1
            if count == 2:
                count = 0
                # 通知转换完成
                self.c_event.set()
                
                # 等待打包完成
                self.t_event.wait()
                self.t_event.clear()
                

    def csv_to_xml(self, csv_file, xml_path):
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

class TarThread(Thread):
    def __init__(self, c_event, t_event):
        super().__init__(daemon=True)
        self.count = 0
        self.c_event = c_event
        self.t_event = t_event

    def run(self):
        while True:
            # wait會等待set調用，否則阻賽
            # 等待足够的xml
            self.c_event.wait()
            # 如果需要重復使用事件需要在wait之後再執行clear
            self.c_event.clear()
            
            print('DEBUG')
            # 打包
            self.tar_xml()

            # 通知打包完成
            self.t_event.set()

    def tar_xml(self):
        self.count += 1
        tfname = 'data%s.tgz' % self.count
        print('tar %s...' % tfname)
        tf = tarfile.open(tfname, 'w:gz')
        for fname in os.listdir('.'):
            if fname.endswith('.xml'):
                tf.add(fname)
                os.remove(fname)
        tf.close()

        if not tf.members:
            os.remove(tfname)

from threading import Event

if __name__ == '__main__':
    queue = Queue()
    c_event= Event()
    t_event= Event()
    thread_list = []
    for i in range(1, 15):
        t = DownloadThread(i, queue)
        t.start()
        thread_list.append(t)

    convert_thread = ConvertThread(queue, c_event, t_event)
    convert_thread.start()

    tar_thread = TarThread(c_event, t_event)
    tar_thread.start()
    
    # 等待下载线程结束
    for t in thread_list:
        t.join()

    # 通知Convert线程退出
    queue.put((-1, None))

    # 等待转换线程结束
    convert_thread.join()
    print('main thread end.')