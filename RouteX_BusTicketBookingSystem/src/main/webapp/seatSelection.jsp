<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.utility.DBConnection" %>

<%
    // =========================================================
    // 1. CHECK LOGIN
    // =========================================================

    if (session.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }


    // =========================================================
    // 2. GET BUS ID
    // =========================================================

    String busIdParam = request.getParameter("busId");

    if (busIdParam == null || busIdParam.trim().isEmpty()) {
        response.sendRedirect("searchBus.jsp");
        return;
    }

    int busId = 0;

    try {
        busId = Integer.parseInt(busIdParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("searchBus.jsp");
        return;
    }


    // =========================================================
    // 3. BUS DETAILS
    // =========================================================

    String busName = "";
    String source = "";
    String destination = "";
    String travelDate = "";
    String departureTime = "";
    String arrivalTime = "";

    int totalSeats = 40;


    // =========================================================
    // 4. STORE BOOKED SEATS
    // =========================================================

    Set<Integer> bookedSeats = new HashSet<>();


    Connection con = null;

    PreparedStatement psBus = null;
    PreparedStatement psBooked = null;

    ResultSet rsBus = null;
    ResultSet rsBooked = null;


    try {

        con = DBConnection.getConnection();

        if (con == null) {
            throw new Exception("Database connection failed.");
        }


        // =====================================================
        // GET BUS DETAILS
        // =====================================================

        String busSql =
            "SELECT bus_name, source, destination, travel_date, " +
            "departure_time, arrival_time, total_seats " +
            "FROM buses WHERE bus_id = ?";


        psBus = con.prepareStatement(busSql);

        psBus.setInt(1, busId);

        rsBus = psBus.executeQuery();


        if (rsBus.next()) {

            busName =
                rsBus.getString("bus_name");

            source =
                rsBus.getString("source");

            destination =
                rsBus.getString("destination");

            travelDate =
                rsBus.getString("travel_date");

            departureTime =
                rsBus.getString("departure_time");

            arrivalTime =
                rsBus.getString("arrival_time");

            totalSeats =
                rsBus.getInt("total_seats");

        } else {

            response.sendRedirect("searchBus.jsp");
            return;
        }


        rsBus.close();
        psBus.close();


        // =====================================================
        // GET ALREADY BOOKED SEATS
        // =====================================================

        String bookedSql =
            "SELECT seat_number " +
            "FROM bookings " +
            "WHERE bus_id = ? " +
            "AND status = 'CONFIRMED'";


        psBooked =
            con.prepareStatement(bookedSql);

        psBooked.setInt(1, busId);

        rsBooked =
            psBooked.executeQuery();


        while (rsBooked.next()) {

            int seatNumber =
                rsBooked.getInt("seat_number");

            bookedSeats.add(seatNumber);
        }


    } catch (Exception e) {

        e.printStackTrace();

    } finally {

        try {
            if (rsBooked != null)
                rsBooked.close();
        } catch (Exception e) {
        }

        try {
            if (psBooked != null)
                psBooked.close();
        } catch (Exception e) {
        }

        try {
            if (rsBus != null)
                rsBus.close();
        } catch (Exception e) {
        }

        try {
            if (psBus != null)
                psBus.close();
        } catch (Exception e) {
        }

        try {
            if (con != null)
                con.close();
        } catch (Exception e) {
        }
    }
%>
 
<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Select Seats - RouteX</title>

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

            margin: 40px auto;

        }


        /* =================================================
           BUS INFORMATION
           ================================================= */

        .bus-card {

            background-color: white;

            border-radius: 12px;

            padding: 25px;

            margin-bottom: 25px;

            box-shadow:
                0 4px 15px rgba(0,0,0,0.08);

        }


        .bus-route {

            font-size: 20px;

            font-weight: bold;

        }


        .arrow {

            margin: 0 15px;

            color: #0d6efd;

        }


        /* =================================================
           SEAT SECTION
           ================================================= */

        .seat-section {

            background-color: white;

            border-radius: 12px;

            padding: 30px;

            box-shadow:
                0 4px 15px rgba(0,0,0,0.08);

        }


        /* =================================================
           SEAT LAYOUT
           ================================================= */

        .seat-layout {

            max-width: 600px;

            margin: 25px auto;

        }


        .seat-row {

            display: flex;

            justify-content: center;

            align-items: center;

            gap: 12px;

            margin-bottom: 12px;

        }


        .seat {

            width: 55px;

            height: 45px;

        }


        /*
         * Hide actual checkbox
         */

        .seat-checkbox {

            display: none;

        }


        /*
         * Visible seat
         */

        .seat-label {

            width: 55px;

            height: 45px;

            display: flex;

            justify-content: center;

            align-items: center;

            border-radius: 8px;

            font-weight: bold;

            cursor: pointer;

            transition: 0.2s;

        }


        /* =================================================
           AVAILABLE SEAT
           ================================================= */

        .available-seat {

            background-color: white;

            color: #0d6efd;

            border: 2px solid #0d6efd;

        }


        .available-seat:hover {

            background-color: #e7f1ff;

        }


        /* =================================================
           SELECTED SEAT
           ================================================= */

        .seat-checkbox:checked + .seat-label {

            background-color: #198754;

            border-color: #198754;

            color: white;

        }


        /* =================================================
           BOOKED SEAT
           ================================================= */

        .booked-seat {

            background-color: #dc3545;

            border-color: #dc3545;

            color: white;

            cursor: not-allowed;

            opacity: 0.75;

        }


        /* =================================================
           LEGEND
           ================================================= */

        .legend {

            display: flex;

            justify-content: center;

            gap: 30px;

            flex-wrap: wrap;

            margin: 25px 0;

        }


        .legend-item {

            display: flex;

            align-items: center;

            gap: 8px;

        }


        .legend-box {

            width: 25px;

            height: 25px;

            border-radius: 5px;

        }


        .legend-available {

            background-color: white;

            border: 2px solid #0d6efd;

        }


        .legend-selected {

            background-color: #198754;

            border: 2px solid #198754;

        }


        .legend-booked {

            background-color: #dc3545;

            border: 2px solid #dc3545;

        }


        /* =================================================
           PASSENGER DETAILS
           ================================================= */

        .passenger-card {

            border: 1px solid #dee2e6;

            border-radius: 10px;

            padding: 20px;

            margin-bottom: 15px;

            background-color: #f8f9fa;

        }


        .passenger-title {

            font-weight: bold;

            color: #0d6efd;

            margin-bottom: 18px;

            font-size: 18px;

        }


        /* =================================================
           BUTTON
           ================================================= */

        .continue-button {

            min-width: 220px;

        }

    </style>

</head>


<body>

<div class="container container-box">


    <!-- =====================================================
         BUS INFORMATION
         ===================================================== -->

    <div class="bus-card">

        <h3 class="text-center mb-4">

            <%= busName %>

        </h3>


        <div class="text-center bus-route">

            <span>
                <%= source %>
            </span>

            <span class="arrow">
                →
            </span>

            <span>
                <%= destination %>
            </span>

        </div>


        <div class="row text-center mt-4">

            <div class="col-md-4">

                <strong>
                    Travel Date
                </strong>

                <br>

                <%= travelDate %>

            </div>


            <div class="col-md-4">

                <strong>
                    Departure
                </strong>

                <br>

                <%= departureTime %>

            </div>


            <div class="col-md-4">

                <strong>
                    Arrival
                </strong>

                <br>

                <%= arrivalTime %>

            </div>

        </div>

    </div>



    <!-- =====================================================
         SEAT SELECTION
         ===================================================== -->

    <div class="seat-section">


        <h3 class="text-center">

            Select Your Seats

        </h3>


        <p class="text-center text-muted">

            Select one or more available seats.

        </p>



        <!-- =================================================
             LEGEND
             ================================================= -->

        <div class="legend">


            <div class="legend-item">

                <div class="legend-box legend-available">
                </div>

                <span>
                    Available
                </span>

            </div>


            <div class="legend-item">

                <div class="legend-box legend-selected">
                </div>

                <span>
                    Selected
                </span>

            </div>


            <div class="legend-item">

                <div class="legend-box legend-booked">
                </div>

                <span>
                    Booked
                </span>

            </div>


        </div>



        <!-- =================================================
             ERROR MESSAGE
             ================================================= -->

        <%
            String error =
                request.getParameter("error");

            if ("booking".equals(error)) {
        %>

            <div class="alert alert-danger text-center">

                Unable to complete the booking.
                Please check the selected seats.

            </div>

        <%
            }
        %>
        <!-- =================================================
             ERROR MESSAGE
             ================================================= -->

        <%
            String error1 =
                request.getParameter("error");

            if ("noseats".equals(error1)) {
        %>

            <div class="alert alert-danger text-center">

                Please select at least one seat.

            </div>

        <%
            }
        %>


        
        
       
        <!-- =================================================
             ERROR MESSAGE
             ================================================= -->

        <%
            String error2 =
                request.getParameter("error");

            if ("invalidData".equals(error2)) {
        %>

            <div class="alert alert-danger text-center">

                Invalid Data
                
            </div>

        <%
            }
        %>
         <!-- =================================================
             ERROR MESSAGE
             ================================================= -->
         <%
            String error3 =
                request.getParameter("error");

            if ("invalid".equals(error3)) {
        %>

            <div class="alert alert-danger text-center">

                Invalid 
                
            </div>

        <%
            }
        %>
         



        <!-- =================================================
             FORM
             ================================================= -->

        <form
            action="BookingServlet"
            method="post"
            id="seatForm">


            <!-- BUS ID -->

            <input
                type="hidden"
                name="busId"
                value="<%= busId %>"
            >



            <!-- =================================================
                 SEAT LAYOUT
                 ================================================= -->

            <div class="seat-layout">


                <%
                    /*
                     * Create seats dynamically.
                     *
                     * Example:
                     *
                     * 1  2    3  4
                     * 5  6    7  8
                     *
                     * ...
                     *
                     * 37 38  39 40
                     */

                    for (
                        int seat = 1;
                        seat <= totalSeats;
                        seat++
                    ) {


                        /*
                         * Start a new row
                         * after every 4 seats.
                         */

                        if ((seat - 1) % 4 == 0) {
                %>

                    <div class="seat-row">

                <%
                        }


                        /*
                         * Check whether this seat
                         * is already booked.
                         */

                        boolean isBooked =
                            bookedSeats.contains(seat);

                %>


                        <div class="seat">


                            <input
                                type="checkbox"
                                class="seat-checkbox"
                                id="seat<%= seat %>"
                                name="selectedSeat"
                                value="<%= seat %>"
                                <%= isBooked
                                    ? "disabled"
                                    : "" %>
                            >


                            <label
                                for="seat<%= seat %>"
                                class="seat-label
                                <%= isBooked
                                    ? "booked-seat"
                                    : "available-seat" %>"
                            >

                                <%= seat %>

                            </label>


                        </div>


                <%
                        /*
                         * Close row after every 4 seats.
                         */

                        if (
                            seat % 4 == 0 ||
                            seat == totalSeats
                        ) {
                %>

                    </div>

                <%
                        }

                    }
                %>


            </div>



            <!-- =================================================
                 SELECTED SEAT COUNT
                 ================================================= -->

            <div class="text-center mt-3">

                <strong>
                    Selected Seats:
                </strong>

                <span id="selectedCount">
                    0
                </span>

            </div>



            <!-- =================================================
                 PASSENGER DETAILS
                 ================================================= -->

            <div class="mt-4">


                <h4 class="mb-3">

                    Passenger Details

                </h4>


                <div id="passengerDetails">

                    <p
                        class="text-muted text-center"
                        id="noSeatMessage">

                        Please select at least one seat.

                    </p>

                </div>


            </div>



            <!-- =================================================
                 FARE
                 ================================================= -->

            <div class="mt-4">


                <label
                    for="fare"
                    class="form-label">

                    Fare Per Seat

                </label>


                <input
                    type="number"
                    class="form-control"
                    id="fare"
                    name="fare"
                    value="700"
                    min="1"
                    step="0.01"
                    required
                >


            </div>



            <!-- =================================================
                 CONTINUE BUTTON
                 ================================================= -->

            <div class="text-center mt-4">


                <button
                    type="submit"
                    class="btn btn-primary btn-lg continue-button"
                    id="continueButton">

                    Continue Booking

                </button>


            </div>


        </form>


    </div>

</div>



<!-- =========================================================
     JAVASCRIPT
     ========================================================= -->

<script>


    /*
     * Get all seat checkboxes.
     */

    const seatCheckboxes =
        document.querySelectorAll(
            ".seat-checkbox"
        );


    /*
     * Passenger details container.
     */

    const passengerDetails =
        document.getElementById(
            "passengerDetails"
        );


    /*
     * Selected seat count.
     */

    const selectedCount =
        document.getElementById(
            "selectedCount"
        );


    /*
     * Booking form.
     */

    const seatForm =
        document.getElementById(
            "seatForm"
        );



    // =========================================================
    // CREATE PASSENGER DETAILS
    // =========================================================

    function updatePassengerDetails() {


        /*
         * Remove previously generated
         * passenger details.
         */

        passengerDetails.innerHTML = "";



        /*
         * Find all selected seats.
         */

        const selectedSeats =
            document.querySelectorAll(
                ".seat-checkbox:checked"
            );



        /*
         * Update count.
         */

        selectedCount.textContent =
            selectedSeats.length;



        /*
         * If no seats are selected.
         */

        if (selectedSeats.length === 0) {


            const message =
                document.createElement("p");


            message.className =
                "text-muted text-center";


            message.textContent =
                "Please select at least one seat.";


            passengerDetails.appendChild(
                message
            );


            return;
        }



        /*
         * Create passenger details
         * for every selected seat.
         */

        selectedSeats.forEach(
            function(seat) {


                const seatNumber =
                    seat.value;



                // =============================================
                // PASSENGER CARD
                // =============================================

                const card =
                    document.createElement(
                        "div"
                    );


                card.className =
                    "passenger-card";



                // =============================================
                // TITLE
                // =============================================

                const title =
                    document.createElement(
                        "div"
                    );


                title.className =
                    "passenger-title";


                title.textContent =
                    "Seat " +
                    seatNumber +
                    " : Passenger Details";



                // =============================================
                // NAME
                // =============================================

                const nameLabel =
                    document.createElement(
                        "label"
                    );


                nameLabel.className =
                    "form-label";


                nameLabel.textContent =
                    "Passenger Name";


                const nameInput =
                    document.createElement(
                        "input"
                    );


                nameInput.type =
                    "text";


                nameInput.className =
                    "form-control";


                /*
                 * Example:
                 *
                 * passengerName_3
                 */

                nameInput.name =
                    "passengerName";


                nameInput.id =
                    "passengerName_" +
                    seatNumber;


                nameInput.placeholder =
                    "Enter passenger name";


                nameInput.required =
                    true;



                // =============================================
                // AGE
                // =============================================

                const ageLabel =
                    document.createElement(
                        "label"
                    );


                ageLabel.className =
                    "form-label mt-3";


                ageLabel.textContent =
                    "Age";


                const ageInput =
                    document.createElement(
                        "input"
                    );


                ageInput.type =
                    "number";


                ageInput.className =
                    "form-control";


                /*
                 * Example:
                 *
                 * passengerAge_3
                 */

                ageInput.name =
                    "age";


                ageInput.id =
                    "passengerAge_" +
                    seatNumber;


                ageInput.placeholder =
                    "Enter age";


                ageInput.min =
                    "1";


                ageInput.max =
                    "120";


                ageInput.required =
                    true;



                // =============================================
                // GENDER
                // =============================================

                const genderLabel =
                    document.createElement(
                        "label"
                    );


                genderLabel.className =
                    "form-label mt-3";


                genderLabel.textContent =
                    "Gender";


                const genderSelect =
                    document.createElement(
                        "select"
                    );


                genderSelect.className =
                    "form-select";


                /*
                 * Example:
                 *
                 * passengerGender_3
                 */

                genderSelect.name =
                    "gender";


                genderSelect.id =
                    "passengerGender_" +
                    seatNumber;


                genderSelect.required =
                    true;



                // =============================================
                // GENDER OPTIONS
                // =============================================

                const defaultOption =
                    document.createElement(
                        "option"
                    );


                defaultOption.value =
                    "";


                defaultOption.textContent =
                    "Select Gender";


                defaultOption.selected =
                    true;


                defaultOption.disabled =
                    true;


                genderSelect.appendChild(
                    defaultOption
                );



                const maleOption =
                    document.createElement(
                        "option"
                    );


                maleOption.value =
                    "Male";


                maleOption.textContent =
                    "Male";


                genderSelect.appendChild(
                    maleOption
                );



                const femaleOption =
                    document.createElement(
                        "option"
                    );


                femaleOption.value =
                    "Female";


                femaleOption.textContent =
                    "Female";


                genderSelect.appendChild(
                    femaleOption
                );



                const otherOption =
                    document.createElement(
                        "option"
                    );


                otherOption.value =
                    "Other";


                otherOption.textContent =
                    "Other";


                genderSelect.appendChild(
                    otherOption
                );



                // =============================================
                // ADD ELEMENTS TO CARD
                // =============================================

                card.appendChild(
                    title
                );


                card.appendChild(
                    nameLabel
                );


                card.appendChild(
                    nameInput
                );


                card.appendChild(
                    ageLabel
                );


                card.appendChild(
                    ageInput
                );


                card.appendChild(
                    genderLabel
                );


                card.appendChild(
                    genderSelect
                );



                // =============================================
                // ADD CARD TO PAGE
                // =============================================

                passengerDetails.appendChild(
                    card
                );

            }
        );

    }



    // =========================================================
    // SEAT CHANGE EVENT
    // =========================================================

    seatCheckboxes.forEach(
        function(checkbox) {


            checkbox.addEventListener(
                "change",
                updatePassengerDetails
            );

        }
    );



    // =========================================================
    // FORM VALIDATION
    // =========================================================

    seatForm.addEventListener(
        "submit",
        function(event) {


            /*
             * Get selected seats.
             */

            const selectedSeats =
                document.querySelectorAll(
                    ".seat-checkbox:checked"
                );



            /*
             * No seat selected.
             */

            if (selectedSeats.length === 0) {


                event.preventDefault();


                alert(
                    "Please select at least one seat."
                );


                return;

            }



            /*
             * Validate passenger details
             * for every selected seat.
             */

            for (
                let seat of selectedSeats
            ) {


                const seatNumber =
                    seat.value;



                // =============================================
                // NAME
                // =============================================

                const nameInput =
                    document.getElementById(
                        "passengerName_" +
                        seatNumber
                    );


                if (
                    nameInput == null ||
                    nameInput.value.trim() === ""
                ) {


                    event.preventDefault();


                    alert(
                        "Please enter passenger name for Seat " +
                        seatNumber
                    );


                    nameInput.focus();


                    return;

                }



                // =============================================
                // AGE
                // =============================================

                const ageInput =
                    document.getElementById(
                        "passengerAge_" +
                        seatNumber
                    );


                if (
                    ageInput == null ||
                    ageInput.value.trim() === ""
                ) {


                    event.preventDefault();


                    alert(
                        "Please enter age for Seat " +
                        seatNumber
                    );


                    ageInput.focus();


                    return;

                }



                /*
                 * Check age range.
                 */

                const age =
                    parseInt(
                        ageInput.value
                    );


                if (
                    age < 1 ||
                    age > 120
                ) {


                    event.preventDefault();


                    alert(
                        "Please enter a valid age for Seat " +
                        seatNumber
                    );


                    ageInput.focus();


                    return;

                }



                // =============================================
                // GENDER
                // =============================================

                const genderInput =
                    document.getElementById(
                        "passengerGender_" +
                        seatNumber
                    );


                if (
                    genderInput == null ||
                    genderInput.value === ""
                ) {


                    event.preventDefault();


                    alert(
                        "Please select gender for Seat " +
                        seatNumber
                    );


                    genderInput.focus();


                    return;

                }

            }

        }
    );

</script>


</body>

</html>