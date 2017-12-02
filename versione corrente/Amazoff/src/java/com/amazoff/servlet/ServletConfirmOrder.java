/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author DVD_01
 */
public class ServletConfirmOrder extends HttpServlet {

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
            
            String modalita = request.getParameter("modalita");
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            
            //Chiedi roba al db
            int orderID = -1;
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                //Creo un nuovo ordine
                PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO orders (who_ordered, order_date, address) VALUES (" + userID + ", "
                        + "'" + MyDatabaseManager.GetCurrentDate() + "',"
                        + "1);", connection);
                
                //Ottengo l'orderID
                ResultSet idOrderRS = ps.getGeneratedKeys();
                if(idOrderRS.next())
                    orderID = idOrderRS.getInt(1);
                
                //Prendo i prodotti nel carrello e li aggiungo all'ordine corretto
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id_product FROM cart WHERE id_user = " + userID + ";", connection);
                while(results.next())
                {
                    String productID = results.getString(1);
                    MyDatabaseManager.EseguiStatement("INSERT INTO orders_products (order_id, product_id) VALUES (" + orderID + ", " + productID + ");", connection);
                }
                
                //TODO: segnare i prodotti ordinati come "venduti"
                
                
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/orderCompletedPage.jsp?p=ok&id="+orderID);       
            }
            else
            {
                //session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/orderCompletedPage.jsp?p=err"); 
            }
        }catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletConfirmOrder", ex.toString());
            HttpSession session = request.getSession();
            //session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/orderCompletedPage.jsp?p=err"); 
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
