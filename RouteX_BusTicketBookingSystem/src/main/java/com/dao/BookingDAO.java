package com.dao;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.model.Booking;
import com.utility.DBConnection;

public class BookingDAO {

    public boolean bookTickets(Booking[] bookings) {

        Connection con = null;

        try {

            con = DBConnection.getConnection();

            con.setAutoCommit(false);


            // Insert booking
            String insertSQL =
                "INSERT INTO bookings " +
                "(user_id, bus_id, passenger_name, age, gender, " +
                "seat_number, fare, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";


            PreparedStatement ps =
                con.prepareStatement(insertSQL);


            // Insert every passenger
            for (Booking booking : bookings) {

                ps.setInt(1, booking.getUserId());
                ps.setInt(2, booking.getBusId());
                ps.setString(3, booking.getPassengerName());
                ps.setInt(4, booking.getAge());
                ps.setString(5, booking.getGender());
                ps.setInt(6, booking.getSeatNumber());
                ps.setDouble(7, booking.getFare());
                ps.setString(8, booking.getStatus());

                ps.executeUpdate();
            }


            // Decrease available seats
            String updateSQL =
                "UPDATE buses " +
                "SET available_seats = available_seats - ? " +
                "WHERE bus_id = ? " +
                "AND available_seats >= ?";


            PreparedStatement updatePS =
                con.prepareStatement(updateSQL);


            int numberOfSeats = bookings.length;

            int busId = bookings[0].getBusId();


            updatePS.setInt(1, numberOfSeats);
            updatePS.setInt(2, busId);
            updatePS.setInt(3, numberOfSeats);


            int rows = updatePS.executeUpdate();


            if (rows == 0) {

                con.rollback();

                return false;
            }


            con.commit();

            return true;

        }
        catch (Exception e) {

            e.printStackTrace();

            try {

                if (con != null) {
                    con.rollback();
                }

            } catch (Exception ex) {
                ex.printStackTrace();
            }

            return false;
        }
    }
    
    public List<Booking> getBookingsByUser(int userId)
            throws Exception {

        List<Booking> bookings = new ArrayList<>();

        String sql =
            "SELECT booking_id, user_id, bus_id, " +
            "passenger_name, age, " +
            "gender, seat_number, " +
            "booking_date, fare, status " +
            "FROM bookings " +
            "WHERE user_id = ? " +
            "ORDER BY booking_date DESC";

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)
        ) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Booking booking = new Booking();

                booking.setBookingId(
                    rs.getInt("booking_id")
                );

                booking.setUserId(
                    rs.getInt("user_id")
                );

                booking.setBusId(
                    rs.getInt("bus_id")
                );

                booking.setPassengerName(
                    rs.getString("passenger_name")
                );

                booking.setAge(
                    rs.getInt("age")
                );

                booking.setGender(
                    rs.getString("gender")
                );

                booking.setSeatNumber(
                    rs.getInt("seat_number")
                );

                booking.setBookingDate(
                    rs.getTimestamp("booking_date")
                );

                booking.setFare(
                    rs.getDouble("fare")
                );

                booking.setStatus(
                    rs.getString("status")
                );

                bookings.add(booking);
            }
        }

        return bookings;
    }
    public boolean cancelBooking(int bookingId, int userId)
            throws SQLException {

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            // Start transaction
            con.setAutoCommit(false);

            int busId;

            // 1. Verify ownership and lock the confirmed booking
            String selectSQL =
                "SELECT bus_id FROM bookings " +
                "WHERE booking_id = ? " +
                "AND user_id = ? " +
                "AND status = 'CONFIRMED' FOR UPDATE";

            try (PreparedStatement ps =
                     con.prepareStatement(selectSQL)) {

                ps.setInt(1, bookingId);
                ps.setInt(2, userId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }

                    busId = rs.getInt("bus_id");
                }
            }

            // 2. Mark the booking as cancelled
            String cancelSQL =
                "UPDATE bookings SET status = 'CANCELLED' " +
                "WHERE booking_id = ? " +
                "AND user_id = ? " +
                "AND status = 'CONFIRMED'";

            try (PreparedStatement ps =
                     con.prepareStatement(cancelSQL)) {

                ps.setInt(1, bookingId);
                ps.setInt(2, userId);

                if (ps.executeUpdate() != 1) {
                    con.rollback();
                    return false;
                }
            }

            // 3. Restore one available seat
            String seatSQL =
                "UPDATE buses " +
                "SET available_seats = available_seats + 1 " +
                "WHERE bus_id = ? " +
                "AND available_seats < total_seats";

            try (PreparedStatement ps =
                     con.prepareStatement(seatSQL)) {

                ps.setInt(1, busId);

                if (ps.executeUpdate() != 1) {
                    con.rollback();
                    return false;
                }
            }

            // 4. Save both changes together
            con.commit();

            return true;

        } catch (SQLException e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    e.addSuppressed(rollbackError);
                }
            }

            throw e;

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                } catch (SQLException e) {
                    e.printStackTrace();
                }

                con.close();
            }
        }
    }
}
