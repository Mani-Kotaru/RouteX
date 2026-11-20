package com.controller;

import java.io.IOException;

import com.dao.BookingDAO;
import com.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/CancelBookingServlet")
public class CancelBookingServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check login
        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Get booking ID from the form
            int bookingId = Integer.parseInt(
                request.getParameter("bookingId")
            );

            if (bookingId <= 0) {
                response.sendRedirect(
                    "myBookings.jsp?cancel=invalid"
                );
                return;
            }

            BookingDAO bookingDAO = new BookingDAO();

            boolean cancelled = bookingDAO.cancelBooking(
                bookingId,
                user.getUserId()
            );

            if (cancelled) {
                response.sendRedirect(
                    "myBookings.jsp?cancel=success"
                );
            } else {
                response.sendRedirect(
                    "myBookings.jsp?cancel=failed"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                "myBookings.jsp?cancel=invalid"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                "myBookings.jsp?cancel=error"
            );
        }
    }
}