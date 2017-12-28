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
 * @author Fra
 */
public class ServletAjaxEmailExists extends HttpServlet {

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
        
        String risposta = "false";
        try (PrintWriter out = response.getWriter()) {
        
            String emailReceived = request.getParameter("_email");

            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT email, passrecupero FROM users WHERE email = '" + MyDatabaseManager.EscapeCharacters(emailReceived) + "';", connection);
                
                if(results.isAfterLast()) 
                {
                    risposta = "false";
                }
                else {
                    risposta = "false";
                    while (results.next()) { // se esiste un utente con quella email, ritorno FALSE
                        risposta = "true&/Amazoff/ResetPassword.jsp?tmp="+results.getString(2);
                        //response.sendRedirect(request.getContextPath() + "/ResetPassword.jsp?tmp="+results.getString(2));
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
    }

}
