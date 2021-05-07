websocket是Html5 提供的一个浏览器与服务器间进行全双工通讯的网络技术
双工通信是指在同一时刻信息可以进行双向传输，和打电话一样，说的同时也能听，边说边听

基于http协议—请求
  GET / HTTP/1.1
  Upgrade: websocket
  Connection: Upgrade
  Sec-WebSocket-Key: xxxxxxxxxxxYw==  （是一个Base64加密的密钥）
  Sec-WebSocket-Version: 13  （告诉服务器 ws的版本）
  Origin: http://xxxxxx.com  (来源)
  其中upgrade websocket用于告诉服务器此连接需要升级到websocket

  这意味着你的服务端 需要支持Websocket协议。

服务端响应
  HTTP/1.1 101 Switching Protocols
  Content-Length: 0
  Upgrade: websocket
  Sec-Websocket-Accept: ZEs+c+VBk8Aj01+wJGN7Y15796g=
  Connection: Upgrade

  101 代表是协议切换 
  Sec-WebSocket-Accept表示服务器同意握手建立连接
  接下来就没http什么事了

第三方库 
  go get github.com/gorilla/websocket

创建upgrader对象
  var upgrader = websocket.Upgrader{
    CheckOrigin: func(r *http.Request) bool {
      return true
    },
  }

  http.HandleFunc("/echo", func(w http.ResponseWriter, req *http.Request) {
		c,_:=upgrader.Upgrade(w,req,nil)
		fmt.Println(c.RemoteAddr())
		for {
			err := c.WriteMessage(websocket.TextMessage, []byte("abc"))
			if err != nil {
				log.Println("write:", err)
				break
			}
			time.Sleep(time.Second*2)
		}
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
