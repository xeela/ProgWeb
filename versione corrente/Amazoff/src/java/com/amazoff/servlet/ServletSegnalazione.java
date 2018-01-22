/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import com.amazoff.classes.Notifications;
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
 * @author Caterina
 */
public class ServletSegnalazione extends HttpServlet {

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
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            String orderID = request.getParameter("orderId");
            String productID = request.getParameter("productId");
            String objectID = "";
            
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
            
            if(MyDatabaseManager.cpds != null){
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (userID != null) {
                    
                    /** Interrogo il Db per farmi restituire i dettagli del prodotto specificato */
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id FROM orders_products WHERE order_id = " + orderID + " AND product_id = " + productID + ";", connection);
                
                    while(results.next()) {
                        objectID = results.getString(1);
                    }
                    
                    results = MyDatabaseManager.EseguiQuery("SELECT id FROM users WHERE usertype = 2;", connection);
                    
                    while(results.next()) {
                        Notifications.SendNotification(results.getString(1), objectID, Notifications.NotificationType.ANOMALY, "", connection);    // da inserire link alla pagina di gestione anomalie
                    }
                     
                    results = MyDatabaseManager.EseguiQuery("SELECT shops.id_owner FROM orders_products, products, shops WHERE orders_products.product_id = products.id AND products.id_shop = shops.id AND order_id = " + orderID + " AND product_id = " + productID + ";", connection);
                
                    while(results.next()) {
                        Notifications.SendNotification(results.getString(1), objectID, Notifications.NotificationType.ANOMALY, "", connection); // da inserire link
                    }
                }
                connection.close();
                response.sendRedirect(request.getContextPath() + "/ServletMyOrders");
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
