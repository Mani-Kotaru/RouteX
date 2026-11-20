<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="java.util.List" %>
<%@ page import="com.model.Bus" %>

<%
    List<Bus> buses =
        (List<Bus>) request.getAttribute("buses");

    String source =
        (String) request.getAttribute("source");

    String destination =
        (String) request.getAttribute("destination");

    String travelDate =
        (String) request.getAttribute("travelDate");
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>RouteX - Available Buses</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand"
           href="dashboard.jsp">

            RouteX

        </a>

        <a href="dashboard.jsp"
           class="btn btn-light btn-sm">

            Dashboard

        </a>

    </div>

</nav>


<div class="container mt-5">

    <h3>Available Buses</h3>

    <p class="text-muted">

        <strong><%= source %></strong>
        →
        <strong><%= destination %></strong>

        | Date:
        <strong><%= travelDate %></strong>

    </p>


    <% if (buses == null || buses.isEmpty()) { %>

        <div class="alert alert-warning">

            No buses available for the selected route and date.

        </div>

    <% } else { %>


        <div class="row">

            <% for (Bus bus : buses) { %>

                <div class="col-md-6 mb-4">

                    <div class="card shadow">

                        <div class="card-body">

                            <h5 class="card-title">

                                <%= bus.getBusName() %>

                            </h5>


                            <p>

                                <strong>
                                    <%= bus.getSource() %>
                                </strong>

                                →

                                <strong>
                                    <%= bus.getDestination() %>
                                </strong>

                            </p>


                            <p>
                                Departure:
                                <%= bus.getDepartureTime() %>
                            </p>


                            <p>
                                Arrival:
                                <%= bus.getArrivalTime() %>
                            </p>


                            <p>
                                Available Seats:
                                <strong>
                                    <%= bus.getAvailableSeats() %>
                                </strong>
                            </p>


                            <a href="seatSelection.jsp?busId=<%= bus.getBusId() %>"
                               class="btn btn-primary">

                                Select Bus

                            </a>

                        </div>

                    </div>

                </div>

            <% } %>

        </div>

    <% } %>

</div>

</body>
</html>

