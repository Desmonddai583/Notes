package com.mj;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");

        // 设置CORS（允许别人能够跨域访问）
        response.setHeader("Access-Control-Allow-Origin", "http://localhost:63342");

        StringBuilder sb = new StringBuilder();
        /*
        [
            {"name": "mj1", "age": 11},
            {"name": "mj2", "age": 12},
            {"name": "mj3", "age": 13},
            {"name": "mj4", "age": 14}
        ]
        */
        sb.append("[");
        sb.append("{\"name\": \"mj0\", \"age\": 10},");
        sb.append("{\"name\": \"mj1\", \"age\": 11},");
        sb.append("{\"name\": \"mj2\", \"age\": 12},");
        sb.append("{\"name\": \"mj3\", \"age\": 13},");
        sb.append("{\"name\": \"mj4\", \"age\": 14}");
        sb.append("]");
        response.getWriter().write(sb.toString());
    }
}
