<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>RouteX - User Registration</title>

    <!-- Bootstrap CSS -->
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

        .register-card {
            width: 450px;
            background-color: white;
            border-radius: 12px;
            padding: 30px;
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

        .btn-register {
            width: 100%;
            padding: 10px;
            font-weight: 600;
        }

        .login-link {
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>

<body>

<div class="register-card">

    <div class="brand">
        <h2>RouteX</h2>
        <p>Online Bus Reservation</p>
    </div>

    <form action="RegisterServlet" method="post">

        <!-- Name -->
        <div class="mb-3">
            <label for="name" class="form-label">Full Name</label>
            <input
                type="text"
                class="form-control"
                id="name"
                name="name"
                placeholder="Enter your full name"
                required>
        </div>

        <!-- Email -->
        <div class="mb-3">
            <label for="email" class="form-label">Email Address</label>
            <input
                type="email"
                class="form-control"
                id="email"
                name="email"
                placeholder="Enter your email"
                required>
        </div>

        <!-- Phone -->
        <div class="mb-3">
            <label for="phone" class="form-label">Phone Number</label>
            <input
                type="tel"
                class="form-control"
                id="phone"
                name="phone"
                placeholder="Enter your phone number"
                pattern="^[6-9][0-9]{9}"
                maxlength="10"
                required>
        </div>

        <!-- Password -->
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input
                type="password"
                class="form-control"
                id="password"
                name="password"
                placeholder="Create a password"
                minlength="6"
                required>
        </div>

        <!-- Confirm Password -->
        <div class="mb-3">
            <label for="confirmPassword" class="form-label">
                Confirm Password
            </label>
            <input
                type="password"
                class="form-control"
                id="confirmPassword"
                name="confirmPassword"
                placeholder="Confirm your password"
                minlength="6"
                required>
        </div>
     <%
         String error = request.getParameter("error");

          if ("password".equals(error)) {
     %>

     <div class="alert alert-danger alert-dismissible fade show" role="alert">
         <strong>Password mismatch!</strong>
                 Password and Confirm Password must be the same.
    
          <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>

<%
}
%>
    <%-- Registration failed message --%>
    <% 
        String failed = request.getParameter("error");

        if ("failed".equals(failed)) {
    %>
        <div class="alert alert-success">
            Registration Failed. Please try again.
        </div>
    <%
        }
    %>
        <!-- Register Button -->
        <button type="submit" class="btn btn-primary btn-register">
            Create Account
        </button>

    </form>

    <div class="login-link">
        <span>Already have an account?</span>
        <a href="login.jsp">Login</a>
    </div>

</div>

<!-- Bootstrap JS -->
<script
    src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js">
</script>

</body>
</html>
