package com.controller;

import java.io.IOException;

import com.dao.BookingDAO;
import com.model.Booking;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;


    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {


        // Get session
        HttpSession session = request.getSession();


        // Get logged-in user
        User user = (User) session.getAttribute("user");


        if (user == null) {

            response.sendRedirect("login.jsp");

            return;
        }


        try {

            // Bus ID
            int busId =
                Integer.parseInt(
                    request.getParameter("busId")
                );


            // Multiple values
            String[] seatNumbers =
                request.getParameterValues("selectedSeat");


            String[] passengerNames =
                request.getParameterValues("passengerName");


            String[] ages =
                request.getParameterValues("age");


            String[] genders =
                request.getParameterValues("gender");


            // Check whether seats are selected
            if (seatNumbers == null ||
                seatNumbers.length == 0) {

                response.sendRedirect(
                    "seatSelection.jsp?busId=" +
                    busId +
                    "error=noSeats"
                );

                return;
            }


            // Check array sizes
            
            if (seatNumbers.length != passengerNames.length ||
                seatNumbers.length != ages.length ||
                seatNumbers.length != genders.length) {

                response.sendRedirect(
                    "seatSelection.jsp?busId=" +
                    busId +
                    "&error=invalidData"
                );

                return;
            }


            // Create Booking array
            Booking[] bookings =
                new Booking[seatNumbers.length];


            // Fare per seat
            double fare = 700.00;


            for (int i = 0;
                 i < seatNumbers.length;
                 i++) {


                int seatNumber =
                    Integer.parseInt(
                        seatNumbers[i]
                    );


                int age =
                    Integer.parseInt(
                        ages[i]
                    );


                String passengerName =
                    passengerNames[i];


                String gender =
                    genders[i];


                bookings[i] =
                    new Booking(
                        user.getUserId(),
                        busId,
                        passengerName,
                        age,
                        gender,
                        seatNumber,
                        fare,
                        "CONFIRMED"
                    );
            }


            // DAO
            BookingDAO bookingDAO =
                new BookingDAO();


            boolean result =
                bookingDAO.bookTickets(bookings);


            if (result) {

                // Total fare
                double totalFare =
                    fare * bookings.length;


                // Store total fare in session
                session.setAttribute(
                    "totalFare",
                    totalFare
                );


                session.setAttribute(
                    "bookings",
                    bookings
                );


                response.sendRedirect(
                    "bookingConfirmation.jsp"
                );

            }
            else {

                response.sendRedirect(
                    "seatSelection.jsp?busId=" +
                    busId +
                    "&error=booking"
                );
            }

        }
        catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "seatSelection.jsp?busId=" +
                request.getParameter("busId") +
                "&error=invalid"
            );
        }
    }
}