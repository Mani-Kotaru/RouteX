package com.model;

import java.sql.Timestamp;

public class Booking {

    private int bookingId;
    private int userId;
    private int busId;

    private String passengerName;
    private int age;
    private String gender;

    private int seatNumber;
    private double fare;
    private String status;
    
    private Timestamp bookingDate;

    // Default constructor
    public Booking() {
    }


    // Parameterized constructor
    public Booking(int userId, int busId,
                   String passengerName,
                   int age,
                   String gender,
                   int seatNumber,
                   double fare,
                   String status) {

        this.userId = userId;
        this.busId = busId;
        this.passengerName = passengerName;
        this.age = age;
        this.gender = gender;
        this.seatNumber = seatNumber;
        this.fare = fare;
        this.status = status;
    }


    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }


    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }


    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }


    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }


    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }


    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }


    public int getSeatNumber() {
        return seatNumber;
    }

    public void setSeatNumber(int seatNumber) {
        this.seatNumber = seatNumber;
    }


    public double getFare() {
        return fare;
    }

    public void setFare(double fare) {
        this.fare = fare;
    }


    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }
}