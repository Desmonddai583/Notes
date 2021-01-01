package com.mj;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 判断用户是否登录成功了？
        /*
        request.getSession()的执行流程
        1.如果request没有带JSESSIONID，就会创建新的Session对象
        2.如果request带了JSESSIONID，就会返回对应的Session对象
        * */
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        if ("mj".equals(username)) {
            // 说明Session中有mj这个用户名
            response.setContentType("application/json; charset=UTF-8");
            StringBuilder sb = new StringBuilder();
            sb.append("[");
            sb.append("{\"name\": \"mj0\", \"age\": 10},");
            sb.append("{\"name\": \"mj1\", \"age\": 11},");
            sb.append("{\"name\": \"mj2\", \"age\": 12},");
            sb.append("{\"name\": \"mj3\", \"age\": 13},");
            sb.append("{\"name\": \"mj4\", \"age\": 14}");
            sb.append("]");
            response.getWriter().write(sb.toString());
        } else {
            // 说明mj没有登录成功
            response.setStatus(302);
            response.setHeader("Location", "/cs/login.html");
        }
    }
}
