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
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Gianluca
 */
public class ServletAjaxCarrello extends HttpServlet {

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

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String risposta = "-1";
        try (PrintWriter out = response.getWriter()) {
            ResultSet results;
            
            String idProductReceived = request.getParameter("_idProdotto");

            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
    
                results = MyDatabaseManager.EseguiQuery("DELETE FROM cart WHERE id_product = " + MyDatabaseManager.EscapeCharacters(idProductReceived)+ ";", connection);
                
                if(results.isAfterLast()) //NON SO QUANDO CI ENTRA. se non c'è un utente con quel nome --> ritorno TRUE
                {
                    risposta = "true";
                }
                else {
                    risposta = "true";
                    while (results.next()) { // se esiste un utente con quella email, ritorno FALSE
                        risposta = "false";
                    }
                }
                connection.close();
            }
            else  // ritorno FALSE, c'è stato un errore
            {
                risposta = "false";
            }
            
            // ritorno il risultato alla pagina chiamante
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
            
        }catch (SQLException ex) {
           // ritorno FALSE, c'è stato un errore
            risposta = "false";
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
        }	
        
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
