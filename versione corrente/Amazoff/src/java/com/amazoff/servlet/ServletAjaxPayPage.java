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
            
            //String operazione = request.getParameter("_op");
            String paeseReceived = request.getParameter("_paese");
            String indirizzoReceived = request.getParameter("_indirizzo");
            String cittaReceived = request.getParameter("_citta");
            String provinciaReceived = request.getParameter("_provincia");
            String capReceived = request.getParameter("_cap");
            String tipoAcquistoReceived = request.getParameter("_ritiroOspedizione"); // OSS: per ora non lo mette da nessuna parte
            String userIDReceived = (request.getSession().getAttribute("userID").toString()); 

            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            
            //Chiedi roba al db
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                // controllo se l'utente ha già un indirizzo.
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id_utente FROM user_addresses WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                                
                String esisteUtente = "false";
                while (results.next()) { // se esiste un utente con quell'id, lo memorizzo
                    esisteUtente = results.getString(1);
                }
                
                if(esisteUtente == "false") //Se NON c'è un indirizzo per quel ID utente
                {
                    
                    // ALLORA: aggiungo un nuovo campo nel db
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO user_addresses(id_utente, town, city, address, province, postal_code) " + 
                                                        "VALUES (" + MyDatabaseManager.EscapeCharacters(userIDReceived) + ", " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(paeseReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(indirizzoReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(cittaReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(provinciaReceived) + "', " + MyDatabaseManager.EscapeCharacters(capReceived) + ");", connection);
                }
                else {
                
                    // ALTRIMENTI: aggiorno i valori dell'utente
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE user_addresses SET " + 
                                                        "id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + " , " + 
                                                        "town = '" + MyDatabaseManager.EscapeCharacters(paeseReceived) + "', " + 
                                                        "city = '" + MyDatabaseManager.EscapeCharacters(indirizzoReceived) + "', " + 
                                                        "address = '" + MyDatabaseManager.EscapeCharacters(cittaReceived) + "', " + 
                                                        "province = '" + MyDatabaseManager.EscapeCharacters(provinciaReceived) + "', " +
                                                        "postal_code = " + MyDatabaseManager.EscapeCharacters(capReceived) + 
                                                        " WHERE id_utente = "+ userIDReceived +";", connection);
                }
                risposta = "true";
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
