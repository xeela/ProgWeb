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
 * @author Fra
 */
public class ServletPopulateProductPage extends HttpServlet {

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
            
            String userReceived = request.getParameter("username"); // NULL, ma non viene mai usato
            String idReceived = request.getParameter("id");
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            String jsonObj = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                // Interrogo il Db per farmi dare i prodotti cercati con la searchbar
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM products WHERE id = '" + idReceived + "';", connection);
                
                if(results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noProductFound);
                    response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                    connection.close();
                    return;
                }
                               
                
                //aggiungo i prodotti al json
                boolean isFirstTime = true, isFirstTimeImg = true, isFirstReview = true;
                jsonObj += "{";
                jsonObj += "\"result\":[";
                while (results.next()) {
                    if(!isFirstTime)            //metto la virgola prima dell'oggetto solo se non è il primo
                        jsonObj += ", ";
                    isFirstTime = false;
                    
                    jsonObj += "{";
                    jsonObj += "\"id\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"description\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"price\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"id_shop\": \"" + results.getString(5) + "\",";
                    
                     // in base al prodotto, ricavo il path delle img a lui associate                    
                    //------ TMP --------
                    ResultSet resultsPictures = MyDatabaseManager.EseguiQuery("SELECT id, path FROM pictures WHERE id_product = " + results.getString(1) + ";", connection);
                
                    if(resultsPictures.isAfterLast()) //se non ci sono img per quel prodotto, allora:
                    {
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }
                    jsonObj += "\"pictures\":[";
                    // altrimenti
                    while (resultsPictures.next()) {
                        if(!isFirstTimeImg)            //metto la virgola prima dell'oggetto solo se non è il primo
                            jsonObj += ", ";
                        isFirstTimeImg = false; 
                        
                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + resultsPictures.getString(1) + "\",";
                        jsonObj += "\"path\": \"" + resultsPictures.getString(2) + "\"";
                        jsonObj += "}";
                    }
                    isFirstTimeImg = true;
                    jsonObj += "],";
                    
                    //------ FINE TMP --------
                    
                    //------ TMP --------
                    ResultSet resultsReviews = MyDatabaseManager.EseguiQuery("SELECT * FROM reviews WHERE id_product = " + results.getString(1) + ";", connection);
                
                    if(resultsReviews.isAfterLast()) //se non ci sono img per quel prodotto, allora:
                    {
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }
                    jsonObj += "\"reviews\":[";
                    // altrimenti
                    while (resultsReviews.next()) {
                        if(!isFirstReview)            //metto la virgola prima dell'oggetto solo se non è il primo
                            jsonObj += ", ";
                        isFirstReview = false; 
                        
                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + resultsReviews.getString(1) + "\",";
                        jsonObj += "\"global_value\": \"" + resultsReviews.getString(2) + "\",";
                        jsonObj += "\"quality\": \"" + resultsReviews.getString(3) + "\",";
                        jsonObj += "\"service\": \"" + resultsReviews.getString(4) + "\",";
                        jsonObj += "\"value_for_money\": \"" + resultsReviews.getString(5) + "\",";
                        jsonObj += "\"name\": \"" + resultsReviews.getString(6) + "\",";
                        jsonObj += "\"description\": \"" + resultsReviews.getString(7) + "\",";
                        jsonObj += "\"date_creation\": \"" + resultsReviews.getString(8) + "\",";
                        jsonObj += "\"id_creator\": \"" + resultsReviews.getString(10) + "\"";
                        jsonObj += "}";
                    }
                    isFirstTimeImg = true;
                    jsonObj += "]";
                    
                    //------ FINE TMP --------
                    
                    
                    jsonObj += "}";
                }
                jsonObj += "]}";
                
                connection.close();
                
                HttpSession session = request.getSession();  
                session.setAttribute("jsonProdotti", jsonObj);
                response.sendRedirect(request.getContextPath() + "/productPage.jsp"); //TODO: Gestire meglio l'errore
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        }catch (SQLException ex) {
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
