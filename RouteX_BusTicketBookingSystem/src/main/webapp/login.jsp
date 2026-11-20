
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>RouteX - Login</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <style>
        body {
            background-color: #f4f6f9;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-card {
            width: 420px;
            background-color: white;
            border-radius: 12px;
            padding: 35px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.15);
        }

        .brand {
            text-align: center;
            margin-bottom: 25px;
        }

        .brand h2 {
            font-weight: bold;
        }

        .brand p {
            color: #6c757d;
        }

        .btn-login {
            width: 100%;
            padding: 10px;
            font-weight: 600;
        }

        .register-link {
            text-align: center;
            margin-top: 18px;
        }
    </style>
</head>

<body>

<div class="login-card">

    <div class="brand">
        <h2>RouteX</h2>
        <p>Online Bus Reservation</p>
    </div>

    <%-- Registration success message --%>
    <% 
        String success = request.getParameter("success");

        if ("registered".equals(success)) {
    %>
        <div class="alert alert-success">
            Registration successful. Please login to continue.
        </div>
    <%
        }
    %>
    <%-- Login error message --%> 
    <% String error = request.getParameter("error"); 
        if ("invalid".equals(error)) { %> 
        <div class="alert alert-danger"> Invalid email or password. </div>
     <% } %>
    

    <form action="LoginServlet" method="post">

        <div class="mb-3">
            <label for="email" class="form-label">
                Email Address
            </label>

            <input
                type="email"
                class="form-control"
                id="email"
                name="email"
                placeholder="Enter your email"
                required>
        </div>

        <div class="mb-3">
            <label for="password" class="form-label">
                Password
            </label>

            <input
                type="password"
                class="form-control"
                id="password"
                name="password"
                placeholder="Enter your password"
                required>
        </div>

        <button type="submit"
                class="btn btn-primary btn-login">
            Login
        </button>

    </form>
    
    <div class="register-link">
        Don't have an account?
        <a href="register.jsp">Create Account</a>
    </div>

</div>

</body>
</html>
