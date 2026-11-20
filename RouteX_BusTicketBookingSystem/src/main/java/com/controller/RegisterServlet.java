package com.controller;


import java.io.IOException;

import com.dao.UserDAO;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");

        // Check password confirmation
        if (!password.equals(confirmPassword)) {

            response.sendRedirect("register.jsp?error=password");
            return;
        }

        User user = new User(name,email,password,phone);

       UserDAO dao = new UserDAO();

        boolean status = dao.registerUser(user); 
        if (status) {

            response.sendRedirect("login.jsp?success=registered");

        } else {

            response.sendRedirect("register.jsp?error=failed");
        }
    }
}