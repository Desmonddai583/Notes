package com.mj;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        response.setContentType("text/html; charset=UTF-8");
        if ("mj".equals(username) && "mj".equals(password)) {
            // 将用户信息存放到Session中
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("password", password);

            response.getWriter().write("<h1 style=\"color:blue\">登录成功！！！</h1>");
        } else {
            response.getWriter().write("<h1 style=\"color:red\">登录失败！！！</h1>");
            // 销毁Session
            request.getSession().invalidate();
        }
    }
}
