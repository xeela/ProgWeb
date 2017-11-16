/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.sql.Connection;

/**
 *
 * @author Fra
 */
public class ServletPayPage extends HttpServlet {


    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userIDReceived = (request.getSession().getAttribute("userID")).toString();
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            String jsonObj = "";
            boolean isFirstTime = true;
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM user_addresses  WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                
                if(results.isAfterLast()) //se non c'è un utente con quel nome
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.usernameDoesntExist);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }
                
                jsonObj += "{";
                jsonObj += "\"addressdata\":[";
                
                // OSS: Per ora restituisco tutto
                while (results.next()) {
                    if(isFirstTime == false) {
                        jsonObj += ",";
                    }
                    jsonObj += "{";
                    jsonObj += "\"id\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"id_utente\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"town\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"city\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"address\": \"" + results.getString(5) + "\",";
                    jsonObj += "\"province\": \"" + results.getString(6) + "\",";
                    jsonObj += "\"postal_code\": \"" + results.getString(7) + "\"";
                    jsonObj += "}";
                }
                jsonObj += "]";
                
                results = MyDatabaseManager.EseguiQuery("SELECT * FROM creditcards  WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                if(results.isAfterLast()) //se non c'è un utente con quel nome
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.usernameDoesntExist);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }
                else 
                {
                    jsonObj += ",\"paymentdata\":[";
                    isFirstTime = true;
                    // OSS: Per ora restituisco tutto
                    while (results.next()) {
                        if(isFirstTime == false) {
                            jsonObj += ",";
                        }
                        jsonObj += "{";
                        jsonObj += "\"owner\": \"" + results.getString(1) + "\",";
                        jsonObj += "\"card_number\": \"" + results.getString(2) + "\","; // TO DO: ritornare una stringa di N asterischi e solo le ultime 2 cifre visibili
                        jsonObj += "\"exp_month\": \"" + results.getString(3) + "\",";
                        jsonObj += "\"exp_year\": \"" + results.getString(4) + "\"";
                        jsonObj += "}";
                        isFirstTime = false;
                    }
                    jsonObj += "]";
                }
                jsonObj += "}";
                
                
                HttpSession session = request.getSession();
                session.setAttribute("jsonPayPage", jsonObj);  
                
                //Crea il json del carrello
                results = MyDatabaseManager.EseguiQuery("SELECT name, description, price, products.id FROM products, cart "
                    + "WHERE ID_USER = " + session.getAttribute("userID") + " AND ID_PRODUCT = products.ID;", connection);
                    jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);
                
                session.setAttribute("shoppingCartProducts", jsonObj);
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/payPage.jsp");       
            }
            else
            {
                HttpSession session = request.getSession();
                //session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/payPage"); //TODO: Gestire meglio l'errore
            }
        }catch (SQLException ex) {
            //MyDatabaseManager.LogError(request.getParameter("username"), "ServletLogin", ex.toString());
            HttpSession session = request.getSession();
            //session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/payPage"); //TODO: Gestire meglio l'errore
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
