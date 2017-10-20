/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Davide
 */
public class ServletDopoRegistrazione extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String paese = request.getParameter("paese");
            String indirizzo = request.getParameter("indirizzo");
            String citta = request.getParameter("citta");
            String provincia = request.getParameter("provincia");
            String cap = request.getParameter("cap");
            
            String intestatario = request.getParameter("intestatario");
            String numeroCarta = request.getParameter("numerocarta");
            String meseScadenza = request.getParameter("mesescadenza");
            String annoScadenza = request.getParameter("annoscadenza");
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            if(MyDatabaseManager.cpds != null)
            {
                HttpSession session = request.getSession();
                Connection connection = MyDatabaseManager.CreateConnection();
                
                MyDatabaseManager.EseguiStatement("INSERT INTO user_addresses(ID_UTENTE, TOWN, CITY, ADDRESS, PROVINCE, POSTAL_CODE)"
                        + " VALUES("
                        + session.getAttribute("userID") + ","
                        + "'" + paese + "',"
                        + "'" + citta + "',"
                        + "'" + indirizzo + "',"
                        + "'" + provincia + "',"
                        + "'" + cap + "');", connection);
                
                MyDatabaseManager.EseguiStatement("INSERT INTO creditcards(ID_UTENTE, OWNER, CARD_NUMBER, EXP_MONTH, EXP_YEAR)"
                        + " VALUES("
                        + session.getAttribute("userID") + ","
                        + "'" + intestatario + "',"
                        + "'" + numeroCarta + "',"
                        + "'" + meseScadenza + "',"
                        + "'" + annoScadenza + "');", connection);
                
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        }
        catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletDopoRegistrazione", ex.toString());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
