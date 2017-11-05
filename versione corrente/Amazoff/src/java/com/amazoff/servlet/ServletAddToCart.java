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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author DVD_01
 */
public class ServletAddToCart extends HttpServlet {

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
            String productReceived = request.getParameter("productID");

            if (!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            //Chiedi roba al db
            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();
                if (session.getAttribute("user") != null) {
                    // Interrogo il Db per farmi dare i prodotti cercati con la searchbar
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO cart(ID_USER, ID_PRODUCT, DATE_ADDED) VALUES ("
                            + session.getAttribute("userID") + ", "
                            + productReceived + ", "
                            + "'" + MyDatabaseManager.GetCurrentDate() + "');", connection);

                    //Crea il json per il carrello
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT name, description, price, products.id FROM products, cart "
                            + "WHERE ID_USER = " + session.getAttribute("userID") + " AND ID_PRODUCT = products.ID;", connection);
                    jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);

                } else {
                    //SALVA NEL COOKIE, DA TESTARE

                    // salva nel carrello
                    String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date());
                    Cookie cookie = new Cookie(timeStamp, productReceived);
                    cookie.setMaxAge(60 * 60 * 24 * 7);
                    response.addCookie(cookie);

                    // mostra carrello
                    Cookie[] cart = request.getCookies();
                    if (cart != null) {
                        Cookie item;
                        ResultSet[] results = null;
                        
                        for (int i = 0; i < cart.length; i++) {
                            item = cart[i];
                            results[i] = MyDatabaseManager.EseguiQuery("SELECT name, description, price, id FROM products WHERE id = " + item.getValue(), connection);
                        }
                        
                        jsonObj = MyDatabaseManager.GetJsonOfProductsInSetList(results, connection);
                    }
                }

                connection.close();
                session.setAttribute("shoppingCartProducts", jsonObj);
                response.sendRedirect(request.getContextPath() + "/shopping-cartPage.jsp");
            } else {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        } catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletAddToCart", ex.toString());
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
