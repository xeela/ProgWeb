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
public class ServletIndexProducts extends HttpServlet {

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
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT name, description, price, id FROM products ORDER BY id DESC LIMIT 6;", connection);
                
                if(results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noProductFound);
                    response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                    connection.close();
                    return;
                }
                               
                
                //aggiungo i prodotti al json
                boolean isFirstTime = true, isFirstTimeImg = true;
                jsonObj += "{";
                jsonObj        += "\"searched\": \"" + "" + "\",";
                jsonObj        += "\"products\":[";
                while (results.next()) {
                    if(!isFirstTime)            //metto la virgola prima dell'oggetto solo se non è il primo
                        jsonObj += ", ";
                    isFirstTime = false;
                    
                    jsonObj += "{";
                    jsonObj += "\"id\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"name\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"description\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"price\": \"" + results.getString(3) + "\",";
                    
                     // in base al prodotto, ricavo il path delle img a lui associate
                    // TO DO:::::::: String s = productPictures(results.getString(4));
                    
                    //------ TMP --------
                    ResultSet results2 = MyDatabaseManager.EseguiQuery("SELECT id, path FROM pictures WHERE id_product = " + results.getString(4) + ";", connection);
                
                    if(results2.isAfterLast()) //se non ci sono img per quel prodotto, allora:
                    {
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }
                    jsonObj        += "\"pictures\":[";
                    // altrimenti   
                    while (results2.next()) {
                        if(!isFirstTimeImg)            //metto la virgola prima dell'oggetto solo se non è il primo
                            jsonObj += ", ";
                        isFirstTimeImg = false; 
                        
                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + results2.getString(1) + "\",";
                        jsonObj += "\"path\": \"" + results2.getString(2) + "\"";
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
                session.setAttribute("jsonProdottiIndex", jsonObj);
                response.sendRedirect(request.getContextPath() + "/index.jsp"); //TODO: Gestire meglio l'errore
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        }catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletIndexProducts", ex.toString());
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
