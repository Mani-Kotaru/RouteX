package com.controller;


import java.io.IOException;
import java.util.List;

import com.dao.BusDAO;
import com.model.Bus;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SearchBusServlet")
public class SearchBusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String source =
                request.getParameter("source");

        String destination =
                request.getParameter("destination");

        String travelDate =
                request.getParameter("travelDate");


        BusDAO dao = new BusDAO();

        List<Bus> buses =
                dao.searchBuses(
                    source,
                    destination,
                    travelDate
                );


        request.setAttribute("buses", buses);

        request.setAttribute("source", source);

        request.setAttribute("destination", destination);

        request.setAttribute("travelDate", travelDate);


        request.getRequestDispatcher(
                "availableBuses.jsp")
               .forward(request, response);
    }
}
