<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="com.model.Booking" %>
<%@ page import="com.model.User" %>

<%
    // =========================================================
    // CHECK LOGIN
    // =========================================================

    User user =
        (User) session.getAttribute("user");

    if (user == null) {

        response.sendRedirect("login.jsp");

        return;
    }


    // =========================================================
    // GET BOOKING DETAILS FROM SESSION
    // =========================================================

    Booking[] bookings =
        (Booking[]) session.getAttribute("bookings");


    Double totalFare =
        (Double) session.getAttribute("totalFare");


    // =========================================================
    // CHECK WHETHER BOOKING DATA EXISTS
    // =========================================================

    if (bookings == null ||
        bookings.length == 0) {

        response.sendRedirect("dashboard.jsp");

        return;
    }


    if (totalFare == null) {

        totalFare = 0.0;

    }
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Booking Confirmation - RouteX</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1">


    <!-- =====================================================
         BOOTSTRAP
         ===================================================== -->

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">


    <!-- =====================================================
         CSS
         ===================================================== -->

    <style>

        body {

            background-color: #f5f7fa;

        }


        .container-box {

            max-width: 1000px;

            margin: 50px auto;

        }


        .confirmation-card {

            background-color: white;

            border-radius: 15px;

            padding: 35px;

            box-shadow:
                0 5px 20px rgba(0,0,0,0.08);

        }


        .success-icon {

            width: 70px;

            height: 70px;

            background-color: #198754;

            color: white;

            border-radius: 50%;

            display: flex;

            justify-content: center;

            align-items: center;

            margin: 0 auto 20px;

            font-size: 35px;

            font-weight: bold;

        }


        .confirmation-title {

            color: #198754;

            font-weight: bold;

        }


        .booking-table {

            margin-top: 30px;

        }


        .booking-table th {

            background-color: #0d6efd;

            color: white;

        }


        .total-box {

            background-color: #e9f7ef;

            border-radius: 10px;

            padding: 20px;

            margin-top: 25px;

        }


        .total-amount {

            color: #198754;

            font-size: 24px;

            font-weight: bold;

        }


        .booking-id-note {

            color: #6c757d;

            font-size: 14px;

        }

    </style>

</head>


<body>


<div class="container container-box">


    <div class="confirmation-card">


        <!-- =================================================
             SUCCESS MESSAGE
             ================================================= -->

        <div class="text-center">


            <div class="success-icon">

                ✓

            </div>


            <h2 class="confirmation-title">

                Booking Confirmed!

            </h2>


            <p class="text-muted">

                Your bus tickets have been successfully booked.

            </p>


        </div>



        <!-- =================================================
             CUSTOMER INFORMATION
             ================================================= -->

        <div class="mt-4">

            <h5>

                Booking Details

            </h5>


            <p class="mb-1">

                <strong>Customer Name:</strong>

                <%= user.getName() %>

            </p>


            <p class="mb-1">

                <strong>Email:</strong>

                <%= user.getEmail() %>

            </p>


            <p class="mb-1">

                <strong>Number of Seats:</strong>

                <%= bookings.length %>

            </p>

        </div>



        <!-- =================================================
             PASSENGER DETAILS
             ================================================= -->

        <div class="table-responsive booking-table">
          
          <h5>

                Passenger Details

            </h5>

            <table class="table table-bordered text-center align-middle">


                <thead>

                    <tr>

                        <th>
                            Seat Number
                        </th>

                        <th>
                            Passenger Name
                        </th>

                        <th>
                            Age
                        </th>

                        <th>
                            Gender
                        </th>

                        <th>
                            Fare
                        </th>

                        <th>
                            Status
                        </th>

                    </tr>

                </thead>


                <tbody>


                <%
                    for (Booking booking : bookings) {
                %>


                    <tr>


                        <td>

                            <strong>
                                <%= booking.getSeatNumber() %>
                            </strong>

                        </td>


                        <td>

                            <%= booking.getPassengerName() %>

                        </td>


                        <td>

                            <%= booking.getAge() %>

                        </td>


                        <td>

                            <%= booking.getGender() %>

                        </td>


                        <td>

                            ₹<%= String.format(
                                "%.2f",
                                booking.getFare()
                            ) %>

                        </td>


                        <td>

                            <span
                                class="badge bg-success">

                                <%= booking.getStatus() %>

                            </span>

                        </td>


                    </tr>


                <%
                    }
                %>


                </tbody>


            </table>


        </div>



        <!-- =================================================
             TOTAL FARE
             ================================================= -->

        <div class="total-box">


            <div class="row align-items-center">


                <div class="col-md-8">


                    <h5 class="mb-1">

                        Total Amount

                    </h5>


                    <p class="text-muted mb-0">

                        <%= bookings.length %>
                        seat(s) × ₹<%= String.format(
                            "%.2f",
                            bookings[0].getFare()
                        ) %>

                    </p>


                </div>


                <div class="col-md-4 text-md-end">


                    <div class="total-amount">

                        ₹<%= String.format(
                            "%.2f",
                            totalFare
                        ) %>

                    </div>


                </div>


            </div>


        </div>



        <!-- =================================================
             MESSAGE
             ================================================= -->

        <div class="alert alert-info text-center mt-4">


            Please keep your booking details
            for future reference.


        </div>



        <!-- =================================================
             BUTTONS
             ================================================= -->

        <div class="text-center mt-4">


            <a
                href="myBookings.jsp"
                class="btn btn-primary me-2">

                My Bookings

            </a>


            <a
                href="dashboard.jsp"
                class="btn btn-outline-secondary">

                Go to Dashboard

            </a>


        </div>


    </div>

</div>


</body>

</html>