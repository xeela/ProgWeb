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

/**
 *
 * @author Fra
 */
public class ServletAjaxPayPage extends HttpServlet {

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
            
            String operazione = request.getParameter("_op");
            String usernameReceived = request.getParameter("_user");
            String paeseReceived = request.getParameter("_paese");
            String indirizzoReceived = request.getParameter("_indirizzo");
            String cittaReceived = request.getParameter("_citta");
            String provinciaReceived = request.getParameter("_provincia");
            String capReceived = request.getParameter("_cap");

            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            
            //Chiedi roba al db
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT user_addresses.id_utente FROM user_addresses, users WHERE users.username = '" + MyDatabaseManager.EscapeCharacters(usernameReceived) + "' AND users.id = user_addresses.id_utente;", connection);
                
                if(results.isAfterLast()) //NON SO QUANDO CI ENTRA. se non c'è un utente con quel nome --> ritorno TRUE
                {
                    risposta = "true";
                }
                else {
                    risposta = "true";
                    String prova = "";
                    while (results.next()) { // se esiste un utente con quella email, ritorno FALSE
                        prova = results.getString(0);
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
