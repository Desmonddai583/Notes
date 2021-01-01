package com.mj.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/form")
public class FormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setStatus(405); // Method Not Allowed
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 对客户端提交的数据进行编码
        req.setCharacterEncoding("UTF-8");

        String name = req.getParameter("name");
        String age = req.getParameter("age");
        String photo = req.getParameter("photo");
        System.out.println(name);
        System.out.println(age);
        System.out.println(photo);

        // 第三方库实现
        // commons-fileupload
    }
}
