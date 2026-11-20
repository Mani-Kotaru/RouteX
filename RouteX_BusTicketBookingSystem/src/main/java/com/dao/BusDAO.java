package com.dao;



import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.model.Bus;
import com.utility.DBConnection;


public class BusDAO {

    public List<Bus> searchBuses(String source,
                                 String destination,
                                 String travelDate) {

        List<Bus> buses = new ArrayList<>();

        String sql = "SELECT * FROM buses "
                   + "WHERE source = ? "
                   + "AND destination = ? "
                   + "AND travel_date = ? "
                   + "AND available_seats > 0";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, source);
            ps.setString(2, destination);
            ps.setString(3, travelDate);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Bus bus = new Bus();

                bus.setBusId(
                    rs.getInt("bus_id")
                );

                bus.setBusName(
                    rs.getString("bus_name")
                );

                bus.setSource(
                    rs.getString("source")
                );

                bus.setDestination(
                    rs.getString("destination")
                );

                bus.setTravelDate(
                    rs.getDate("travel_date")
                );

                bus.setDepartureTime(
                    rs.getTime("departure_time")
                );

                bus.setArrivalTime(
                    rs.getTime("arrival_time")
                );

                bus.setTotalSeats(
                    rs.getInt("total_seats")
                );

                bus.setAvailableSeats(
                    rs.getInt("available_seats")
                );

                buses.add(bus);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return buses;
    }
}