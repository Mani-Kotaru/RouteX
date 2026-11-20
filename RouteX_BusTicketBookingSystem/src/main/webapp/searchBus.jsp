<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1">

    <title>RouteX - Search Buses</title>

    <link
        href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
        rel="stylesheet">

</head>

<body>

<nav class="navbar navbar-dark bg-primary">

    <div class="container">

        <a class="navbar-brand" href="dashboard.jsp">
            RouteX
        </a>

        <a href="LogoutServlet"
           class="btn btn-light btn-sm">
            Logout
        </a>

    </div>

</nav>


<div class="container mt-5">

    <div class="card shadow p-4">

        <h3 class="mb-4">
            Search Available Buses
        </h3>

        <form action="SearchBusServlet" method="post">

            <div class="row">

                <!-- Source -->

                <div class="col-md-4 mb-3">

                    <label class="form-label">
                        From
                    </label>

                    <input
                        type="text"
                        name="source"
                        class="form-control"
                        placeholder="Enter source"
                        required>

                </div>


                <!-- Destination -->

                <div class="col-md-4 mb-3">

                    <label class="form-label">
                        To
                    </label>

                    <input
                        type="text"
                        name="destination"
                        class="form-control"
                        placeholder="Enter destination"
                        required>

                </div>


                <!-- Travel Date -->

                <div class="col-md-4 mb-3">

                    <label class="form-label">
                        Travel Date
                    </label>

                    <input
                        type="date"
                        name="travelDate"
                        class="form-control"
                        required>

                </div>

            </div>


            <button type="submit"
                    class="btn btn-primary">
                Search Buses
            </button>

        </form>

    </div>

</div>

</body>
</html>
