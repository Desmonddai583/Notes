package com.mj;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

public class TCPServer1 {
    public static void main(String[] args) throws Exception {
        try (ServerSocket serverSocket = new ServerSocket(Constants.PORT)) {
            System.out.println("服务器1----开始监听");

            while (true) {
                try {
                    // 等待客户端接入
                    new ServerThread(serverSocket.accept()).start();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static class ServerThread extends Thread {
        private final Socket socket;

        public ServerThread(Socket socket){
            this.socket = socket;
            System.out.println("新的客户端接入：" + socket);
        }

        @Override
        public void run() {
            try (BufferedInputStream bis = new BufferedInputStream(socket.getInputStream())) {
                while (true){
                    byte [] head = new byte[4];
                    bis.read(head);

                    byte [] data = new byte[Bytes.byteArrayToInt(head)];
                    bis.read(data);
                    System.out.println(new String(data, StandardCharsets.UTF_8).trim());
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                try {
                    socket.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
