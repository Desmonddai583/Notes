package com.mj.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * 处理登录请求
 * 1.继承HttpServlet，才能够处理HTTP请求
 * 2.使用@WebServlet，说明它要处理的请求路径
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    /**
     * @param HttpServletRequest req 请求：用来获取客户端发送的数据
     * @param HttpServletResponse resp 响应：用来给客户端返回数据
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1.获取客户端发送的数据（请求参数）
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // 2.判断
        response.setHeader("Content-Type", "text/html; charset=UTF-8");
        if ("123".equals(username) && "456".equals(password)) {
            // 登录成功
            response.getWriter().write("<h1 style=\"color: red\">登录成功!!!</h1>");
        } else {
            // 登录失败
            response.getWriter().write("<h1 style=\"color: blue\">登录失败!!!</h1>");
        }
    }
}
