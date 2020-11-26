package com.mj;

import java.awt.FlowLayout;
import java.awt.Font;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Socket;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

@SuppressWarnings("serial")
public class TCPClient2 extends JFrame {
	
	public TCPClient2() {
		setTitle("客户端2");
		setBounds(300, 300, 600, 400);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		setLayout(new FlowLayout(FlowLayout.LEFT, 20, 20));
		
		// 字体
		Font font = new Font("微软雅黑", Font.PLAIN, 18);
		
		JLabel label = new JLabel();
		label.setFont(font);
		add(label);
		
		JTextField tf = new JTextField(10);
		tf.setFont(font);
		add(tf);
		
		JButton saveBtn = new JButton("发送");
		saveBtn.setFont(font);
		saveBtn.addActionListener((evt) -> {
			try (
				Socket socket = new Socket("127.0.0.1", Constants.PORT);
				OutputStream os = socket.getOutputStream();
				InputStream is = socket.getInputStream();
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
			) {
				// 写数据到服务器
				os.write(tf.getText().getBytes("UTF-8"));
				// 关闭输出（表明写给服务器的内容都写完了）
				socket.shutdownOutput();
				
				// 读取服务器发送的数据
				byte[] buffer = new byte[8192];
				int len;
				while ((len = is.read(buffer)) != -1) {
					baos.write(buffer, 0, len);
				}
				byte[] bytes = baos.toByteArray();
				label.setText(new String(bytes, "UTF-8"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
		add(saveBtn);
		
	}

	public static void main(String[] args) throws Exception, IOException {
		new TCPClient2().setVisible(true);
	}
	
}
