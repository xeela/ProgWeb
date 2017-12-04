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
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Cate
 */
@WebServlet(name = "ServletAjaxAutocompletamento", urlPatterns = {"/ServletAjaxAutocompletamento"})
public class ServletAjaxAutocomplete extends HttpServlet {

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
        
        String risposta = "-1";
        String categoria = request.getParameter("_categoria");
        String query = null;
            
        try (PrintWriter out = response.getWriter()) {
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
    
                switch(categoria){
                    case "product": query = "SELECT DISTINCT name FROM products ORDER BY name ASC;";
                        break;
                    case "category": query = "SELECT DISTINCT category FROM products ORDER BY category ASC;";
                        break;
                    case "seller": query = "SELECT DISTINCT name FROM shops ORDER BY name ASC;";
                        break;
                    default:
                        break;
                }
                
                ResultSet results = MyDatabaseManager.EseguiQuery(query, connection);
                             
                risposta = "";
                
                boolean isFirst = true;
                
                while (results.next()) {
                    if(isFirst){
                        risposta += results.getString(1);
                        isFirst = false;
                    } else {
                        risposta += "," + results.getString(1);
                    }
                }
                
                connection.close();
            }
            
            // ritorno il risultato alla pagina chiamante
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
            
        }catch (SQLException ex) {
            // in caso di errore restituisci -1
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
        }	
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
