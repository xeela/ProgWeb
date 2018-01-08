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
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Cate
 */
public class ServletUpdateReview extends HttpServlet {

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
            String id_recensione = request.getParameter("id_review");
            String id_prodotto = request.getParameter("id_product");
            String titolo = request.getParameter("review_name");
            String recensione = request.getParameter("review_text");
            String quality = request.getParameter("quality_rating");
            String service = request.getParameter("service_rating");
            String value = request.getParameter("value_rating");
            String global = request.getParameter("global_rating");
            String to_update = request.getParameter("to_update");
            HttpSession session = request.getSession();
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (session.getAttribute("userID") != null) {
                    /** Interrogo il Db per farmi restituire i dettagli del prodotto specificato */
                    if(to_update.equals("true")){
                        ResultSet results = MyDatabaseManager.EseguiQuery("UPDATE reviews SET description = '" + recensione + "'"
                                + ", name = '" + titolo + "'"
                                + ", global_value = "+ global
                                + ", quality = " + quality
                                + ", service = " + service
                                + ", value_for_money = " + value
                                + " WHERE id = " + id_recensione + ";", connection);

                        /** se l'update non è andata a buon fine */
                        if(results == null) 
                        {
                            session.setAttribute("errorMessage", Errors.updateUnsuccessful);
                            response.sendRedirect(request.getContextPath() + "/index.jsp");
                        }
                    } else {
                        ResultSet results = MyDatabaseManager.EseguiQuery("INSERT INTO reviews (global_value, quality, service, value_for_money, name, description, date_creation, id_product, id_ creator) VALUES ();", connection);
                        
                        /** se l'insert non è andata a buon fine */
                        if(results == null) 
                        {
                            session.setAttribute("errorMessage", Errors.insertUnsuccessful);
                            response.sendRedirect(request.getContextPath() + "/index.jsp");
                        }
                    }   
                    connection.close();

                    response.sendRedirect(request.getContextPath() + "/myOrders.jsp");
                }
            } else {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/");
            }
        }catch (SQLException ex) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/");
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
