package com.mj;

import java.awt.FlowLayout;
import java.awt.Font;
import java.io.*;
import java.net.Socket;
import java.nio.charset.StandardCharsets;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JTextField;

@SuppressWarnings("serial")
public class TCPClient1 extends JFrame {
	private final Socket socket;
	private final BufferedOutputStream bos;

	public TCPClient1() throws IOException {
		socket = new Socket("127.0.0.1", Constants.PORT);
		bos = new BufferedOutputStream(socket.getOutputStream());

		setTitle("客户端1");
		setBounds(300, 300, 600, 400);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setLayout(new FlowLayout(FlowLayout.LEFT, 20, 20));
		
		// 字体
		Font font = new Font("微软雅黑", Font.PLAIN, 18);
		
		JTextField tf = new JTextField(10);
		tf.setFont(font);
		add(tf);

		JButton saveBtn = new JButton("发送");
		saveBtn.setFont(font);
		saveBtn.addActionListener((evt) -> {
			try {
				// 包体：读取控制台
				byte[] data = tf.getText().getBytes(StandardCharsets.UTF_8);
				// 包头,固定4个字节,包含包体长度信息
				byte[] head = Bytes.intToByteArray(data.length);
				// 写出去
				bos.write(head);
				bos.write(data);
				bos.flush();
			} catch (IOException e) {
				e.printStackTrace();
			}
		});
		add(saveBtn);

//		JButton closeBtn = new JButton("关闭");
//		closeBtn.setFont(font);
//		closeBtn.addActionListener((evt) -> {
//			try {
//				bos.close();
//				socket.close();
//			} catch (IOException e) {
//				e.printStackTrace();
//			}
//		});
//		add(closeBtn);
	}

	public static void main(String[] args) throws IOException {
		new TCPClient1().setVisible(true);
	}
}
