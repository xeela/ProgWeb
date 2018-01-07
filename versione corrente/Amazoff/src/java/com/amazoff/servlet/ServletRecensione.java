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
public class ServletRecensione extends HttpServlet {

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
            String id_prodotto = request.getParameter("id");          
            HttpSession session = request.getSession();
            String jsonObj = "";
            
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
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM reviews, products WHERE reviews.id_product = products.id AND reviews.id_creator = "+ session.getAttribute("userID") +" AND products.id = "+ id_prodotto +";", connection);

                    /** se non c'è il prodotto specificato */
                    if(results == null) 
                    {                    
                        results = MyDatabaseManager.EseguiQuery("SELECT name FROM products WHERE id = "+ id_prodotto +";", connection);
                        
                        if(results == null){
                            jsonObj += "{}";
                        } else{
                            while (results.next()) {
                                jsonObj += "{";
                                jsonObj += "\"name_product\": \"" + results.getString(1) + "\"";
                                jsonObj += "}";
                            }
                        }
                    } else {
                        while (results.next()) {
                            jsonObj += "{";
                            jsonObj += "\"id_review\": \"" + results.getString(1) + "\",";
                            jsonObj += "\"global\": \"" + results.getString(2) + "\",";
                            jsonObj += "\"quality\": \"" + results.getString(3) + "\",";
                            jsonObj += "\"service\": \"" + results.getString(4) + "\",";
                            jsonObj += "\"value\": \"" + results.getString(5) + "\",";
                            jsonObj += "\"title\": \"" + results.getString(6) + "\",";
                            jsonObj += "\"description\": \"" + results.getString(7) + "\",";
                            jsonObj += "\"date\": \"" + results.getString(8) + "\",";
                            jsonObj += "\"id_product\": \"" + results.getString(9) + "\",";
                            jsonObj += "\"id_creator\": \"" + results.getString(10) + "\",";
                            jsonObj += "\"name_product\": \"" + results.getString(12) + "\"";
                            jsonObj += "}";
                        }
                    }                
                    connection.close();

                    session.setAttribute("jsonReview", jsonObj);
                    response.sendRedirect(request.getContextPath() + "/lasciaRecensione.jsp"); 
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
