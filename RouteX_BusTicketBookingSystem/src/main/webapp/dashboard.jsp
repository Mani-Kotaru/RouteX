<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">

    <title>RouteX - Dashboard</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand" href="#">
            RouteX
        </a>

        <div class="text-white">

            Welcome,
            <%= user.getName() %>

            &nbsp;&nbsp;

            <a href="LogoutServlet"
               class="btn btn-light btn-sm">
                Logout
            </a>

        </div>

    </div>

</nav>


<div class="container mt-5">

    <h2>Welcome to RouteX</h2>

    <p class="text-muted">
        Online Bus Reservation System
    </p>

    <div class="row mt-4">

        <div class="col-md-4">

            <div class="card p-3">

                <h5>Search Buses</h5>

                <p>
                    Find buses based on your route and travel date.
                </p>

                <a href="searchBus.jsp"
                   class="btn btn-primary">
                    Search Buses
                </a>

            </div>

        </div>


        <div class="col-md-4">

            <div class="card p-3">

                <h5>My Bookings</h5>

                <p>
                    View your previous and upcoming bookings.
                </p>

                <a href="myBookings.jsp"
                   class="btn btn-primary">
                    View Bookings
                </a>

            </div>

        </div>

    </div>

</div>

</body>
</html>
