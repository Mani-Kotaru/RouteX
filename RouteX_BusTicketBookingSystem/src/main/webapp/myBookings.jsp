<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.model.Booking" %>
<%@ page import="com.model.User" %>
<%@ page import="com.dao.BookingDAO" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>My Bookings - RouteX</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

    <style>

        body {
            background-color: #f4f6f9;
        }

        .navbar-brand {
            font-weight: bold;
            font-size: 24px;
        }

        .booking-card {
            margin-top: 40px;
            background-color: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .page-title {
            font-weight: bold;
            margin-bottom: 25px;
        }

        .table th {
            background-color: #212529;
            color: white;
        }

        .status-confirmed {
            color: green;
            font-weight: bold;
        }

        .status-cancelled {
            color: red;
            font-weight: bold;
        }

        .no-bookings {
            text-align: center;
            padding: 40px;
        }

    </style>

</head>


<body>


<!-- =========================
     NAVBAR
     ========================= -->

<nav class="navbar navbar-dark bg-dark">

    <div class="container">

        <a class="navbar-brand" href="dashboard.jsp">
            RouteX
        </a>

        <div>

            <a href="dashboard.jsp"
               class="btn btn-outline-light me-2">
                Dashboard
            </a>

            <a href="LogoutServlet"
               class="btn btn-danger">
                Logout
            </a>

        </div>

    </div>

</nav>


<!-- =========================
     MAIN CONTENT
     ========================= -->

<div class="container">

    <div class="booking-card">


        <h2 class="page-title">
            My Bookings
        </h2>
         <%
    String cancelStatus = request.getParameter("cancel");

    if ("success".equals(cancelStatus)) {
%>
        <div class="alert alert-success">
            Booking cancelled successfully!
            The seat is now available for other users.
        </div>
<%
    } else if ("failed".equals(cancelStatus)) {
%>
        <div class="alert alert-warning">
            Booking could not be cancelled.
            It may already be cancelled or may not belong to you.
        </div>
<%
    } else if ("invalid".equals(cancelStatus)) {
%>
        <div class="alert alert-danger">
            Invalid booking ID.
        </div>
<%
    } else if ("error".equals(cancelStatus)) {
%>
        <div class="alert alert-danger">
            An error occurred while cancelling the booking.
            Please try again.
        </div>
<%
    }
%>

        <%

            // Get logged-in user from session

            User user =
                (User) session.getAttribute("user");


            // Check whether user is logged in

            if (user == null) {

                response.sendRedirect("login.jsp");

                return;
            }


            try {

                // Create BookingDAO object

                BookingDAO bookingDAO =
                    new BookingDAO();


                // Get bookings of logged-in user

                List<Booking> bookings =
                    bookingDAO.getBookingsByUser(
                        user.getUserId()
                    );


                // Check whether bookings exist

                if (bookings == null ||
                    bookings.isEmpty()) {

        %>


                    <!-- =========================
                         NO BOOKINGS
                         ========================= -->

                    <div class="no-bookings">

                        <h4>
                            No bookings found
                        </h4>

                        <p class="text-muted">
                            You have not booked any tickets yet.
                        </p>

                        <a href="searchBus.jsp"
                           class="btn btn-primary">

                            Book a Ticket

                        </a>

                    </div>


        <%

                }
                else {

        %>


                    <!-- =========================
                         BOOKINGS TABLE
                         ========================= -->

                    <div class="table-responsive">

                        <table
                            class="table table-bordered table-hover align-middle">

                            <thead>

                                <tr>

                                    <th>Booking ID</th>

                                    <th>Bus ID</th>

                                    <th>Passenger Name</th>

                                    <th>Age</th>

                                    <th>Gender</th>

                                    <th>Seat Number</th>

                                    <th>Fare</th>

                                    <th>Booking Date</th>

                                    <th>Status</th>

                                </tr>

                            </thead>


                            <tbody>


                            <%

                                for (Booking booking : bookings) {

                            %>


                                <tr>

                                    <!-- Booking ID -->

                                    <td>
                                        <%= booking.getBookingId() %>
                                    </td>


                                    <!-- Bus ID -->

                                    <td>
                                        <%= booking.getBusId() %>
                                    </td>


                                    <!-- Passenger Name -->

                                    <td>
                                        <%= booking.getPassengerName() %>
                                    </td>


                                    <!-- Age -->

                                    <td>
                                        <%= booking.getAge() %>
                                    </td>


                                    <!-- Gender -->

                                    <td>
                                        <%= booking.getGender() %>
                                    </td>


                                    <!-- Seat Number -->

                                    <td>

                                        <span class="badge bg-primary">

                                            Seat
                                            <%= booking.getSeatNumber() %>

                                        </span>

                                    </td>


                                    <!-- Fare -->

                                    <td>

                                        ₹<%= String.format(
                                                "%.2f",
                                                booking.getFare()
                                            ) %>

                                    </td>


                                    <!-- Booking Date -->

                                    <td>

                                        <%= booking.getBookingDate() %>

                                    </td>


                                    <!-- Status -->

                                    <td>

                                        <%

                                            if ("CONFIRMED".equalsIgnoreCase(
                                                    booking.getStatus())) {

                                        %>

                                            <span class="status-confirmed">
                                                CONFIRMED
                                            </span>
                                            
                                            <td>
                                               <% if ("CONFIRMED".equalsIgnoreCase(
                                                          booking.getStatus())) { %>

											        <form action="CancelBookingServlet"
											              method="post"
											              onsubmit="return confirm(
											                  'Are you sure you want to cancel this booking?'
											              );">
											
											            <input type="hidden"
											                   name="bookingId"
											                   value="<%= booking.getBookingId() %>">
											
											            <button type="submit"
											                    class="btn btn-danger btn-sm">
											                Cancel Booking
											            </button>
											
											        </form>
											
											    <% } else { %>
											
											        <span class="badge bg-secondary">
											            Cancelled
											        </span>
											
											    <% } %>
											</td>

                                        <%

                                            }
                                            else {

                                        %>

                                            <span class="status-cancelled">
                                                <%= booking.getStatus() %>
                                            </span>

                                        <%

                                            }

                                        %>

                                    </td>

                                </tr>


                            <%

                                }

                            %>


                            </tbody>

                        </table>

                    </div>


        <%

                }

            }
            catch (Exception e) {

                e.printStackTrace();

        %>

      
                <div class="alert alert-danger">

                    Unable to load your bookings.

                </div>
      

        <%

            }

        %>


    </div>

</div>


</body>

</html>