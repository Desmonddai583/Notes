package com.mj;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class TCPServer2 {
	public static void main(String[] args) throws Exception {
		try (ServerSocket server = new ServerSocket(Constants.PORT)) {
			System.out.println("服务器2----开始监听");
			while (true) {
				Socket client = server.accept();
				new Thread(() -> {
					try {
						doClient(client);
						client.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}).start();
			}
		}
	}
	
	static void doClient(Socket client) throws Exception {
		try (
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			InputStream is = client.getInputStream();
			OutputStream os = client.getOutputStream();
		) {
			// 读取客户端的数据
			byte[] buffer = new byte[8192];
			int len;
			while ((len = is.read(buffer)) != -1) {
				baos.write(buffer, 0, len);
			}
			byte[] bytes = baos.toByteArray();
			String content = new String(bytes, "UTF-8");
			String ip = client.getInetAddress().getHostAddress();
			System.out.format("服务器2接收到[%s]的数据：%s%n", ip, content);
			
			// 写数据给客户端
			os.write(doString(content).getBytes("UTF-8"));
		}
	}
	
	static String doString(String str) {
		str = str.replace("你", "朕");
		str = str.replace("吗", "");
		str = str.replace("么", "");
		str = str.replace("?", "!");
		return str.replace("？", "!");
	}
	
	static void test() {
//		ServerSocket serverSocket = new ServerSocket(8888);
//		Socket socket = serverSocket.accept();
//		
//		ByteArrayOutputStream baos = new ByteArrayOutputStream();
//        InputStream is = socket.getInputStream();	
//		byte[] buffer = new byte[8192];
//		int len;
//		while ((len = is.read(buffer)) != -1) {
//			baos.write(buffer, 0, len);
//		}
//		byte[] bytes = baos.toByteArray();
//		
//		String string = new String(bytes, "UTF-8");
//		
//		System.out.format("服务器接收到[%s]的数据：%s%n", socket.getInetAddress(), string);
//        
//		is.close();
//        baos.close();
//		socket.close();
//		serverSocket.close();
	}
}
