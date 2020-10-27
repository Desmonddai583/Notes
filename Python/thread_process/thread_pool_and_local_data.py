# from threading import Thread, local
# l = local()
# l.x = 1
# def f(1):
#     l.x = 2
#     print(l.x)
# Thread(target=f, args(l,)).start()
# l.x  // 1
# 這裏使用到了線程的本地數據
# 子線程中的l.x並不會改變主線程中的

import os, cv2, time, struct, threading
from http.server import HTTPServer, BaseHTTPRequestHandler
from socketserver import TCPServer, ThreadingTCPServer
from threading import Thread, RLock
from select import select

class JpegStreamer(Thread):
    def __init__(self, camera):
        super().__init__()
        self.cap = cv2.VideoCapture(camera)
        self.lock = RLock()
        self.pipes = {}

    def register(self):
        pr, pw = os.pipe()
        self.lock.acquire()
        self.pipes[pr] = pw
        self.lock.release()
        return pr

    def unregister(self, pr):
        self.lock.acquire()
        pw = self.pipes.pop(pr)
        self.lock.release()
        os.close(pr)
        os.close(pw)

    def capture(self):
        cap = self.cap
        while cap.isOpened():
            ret, frame = cap.read()
            if ret:
                ret, data = cv2.imencode('.jpg', frame, (cv2.IMWRITE_JPEG_QUALITY, 40))
                yield data.tostring()

    def send_frame(self, frame):
        n = struct.pack('l', len(frame))
        self.lock.acquire()
        if len(self.pipes):
            _, pipes, _ = select([], self.pipes.values(), [], 1)
            for pipe in pipes:
                os.write(pipe, n)
                os.write(pipe, frame)
        self.lock.release()

    def run(self):
        for frame in self.capture():
            self.send_frame(frame)

class JpegRetriever:
    def __init__(self, streamer):
        self.streamer = streamer
        self.local = threading.local()

    def retrieve(self):
        while True:
            ns = os.read(self.local.pipe, 8)
            n = struct.unpack('l', ns)[0]
            data = os.read(self.local.pipe, n)
            yield data

    def __enter__(self):
        if hasattr(self.local, 'pipe'):
            raise RuntimeError()

        self.local.pipe = streamer.register()
        return self.retrieve()

    def __exit__(self, *args):
        self.streamer.unregister(self.local.pipe)
        del self.local.pipe
        return True

class WebHandler(BaseHTTPRequestHandler):
    retriever = None

    @staticmethod
    def set_retriever(retriever):
        WebHandler.retriever = retriever

    def do_GET(self):
        if self.retriever is None:
            raise RuntimeError('no retriver')

        if self.path != '/':
            return

        self.send_response(200) 
        self.send_header('Content-type', 'multipart/x-mixed-replace;boundary=jpeg_frame')
        self.end_headers()

        with self.retriever as frames:
            for frame in frames:
                self.send_frame(frame)

    def send_frame(self, frame):
        sh  = b'--jpeg_frame\r\n'
        sh += b'Content-Type: image/jpeg\r\n'
        sh += b'Content-Length: %d\r\n\r\n' % len(frame)
        self.wfile.write(sh)
        self.wfile.write(frame)

from concurrent.futures import ThreadPoolExecutor
# 這裏通過繼承ThreadingTCPServer並且重寫process_request方法引入線程池
class ThreadingPoolTCPServer(ThreadingTCPServer):
    def __init__(self, server_address, RequestHandlerClass, bind_and_activate=True, thread_n=100):
        super().__init__(server_address, RequestHandlerClass, bind_and_activate=True)

        # 創建一個線程池並指定大小
        self.executor = ThreadPoolExecutor(thread_n)

    def process_request(self, request, client_address):
        # 第一個參數傳入需要執行的函數，後面一次傳入函數參數即可
        # submit返回值是一個future對象
        # future.result() 即可返回函數的返回值，result是一個blocking方法
        # 只有線程執行並返回才會執行
        # 可以通過self.executor.map(f, [1,2,3], [2,3,4]) 執行多個線程
        # 後面的參數分別都是一個列表，列表中的每一個元素代表不同線程的參數
        # 類似f(1,2) f(2,3) f(3,4)
        self.executor.submit(self.process_request_thread, request, client_address)

if __name__ == '__main__':
    # 创建Streamer，开启摄像头采集。
    streamer = JpegStreamer(0)
    streamer.start()

    # http服务创建Retriever
    retriever = JpegRetriever(streamer)
    WebHandler.set_retriever(retriever)

    # 开启http服务器
    HOST = 'localhost'
    PORT = 9000
    print('Start server... (http://%s:%s)' % (HOST, PORT))
    httpd = ThreadingPoolTCPServer((HOST, PORT), WebHandler, thread_n=3)
    #httpd = ThreadingTCPServer((HOST, PORT), WebHandler)
    httpd.serve_forever()