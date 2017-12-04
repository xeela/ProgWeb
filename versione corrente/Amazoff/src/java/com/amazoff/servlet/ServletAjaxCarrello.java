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
 * @author Gianluca
 */
public class ServletAjaxCarrello extends HttpServlet {

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

    /**
     * Questa servlet, riceve l'id di un utente e quello del prodotto che è stato che è stato selezionato per essere rimosso dal carrello
     * 
     * @param request variabile all'interno della quale è contenuto l'id del prodotto da rimuovere dal carrello
     *                  e quello dell'utente che ha richiesto l'operazione
     * @return response all'interno della quale è contenuto TRUE se l'operazione è stata completata correttamente
     *                  FALSE se si sono verificati errori  
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String risposta = "-1";
        try (PrintWriter out = response.getWriter()) {
            
            String idProductReceived = request.getParameter("_idProdotto");
            String idUser = request.getParameter("_idUser");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
    
                /** Elimino l'elemento specificato, come idProductReceived, dal db */
                PreparedStatement result = MyDatabaseManager.EseguiStatement("DELETE FROM cart WHERE id_user = "+ idUser +"  AND  id_product = " + MyDatabaseManager.EscapeCharacters(idProductReceived)+ ";", connection);
                
                risposta = "true";
                connection.close();
            }
            else  /** ritorno FALSE, c'è stato un errore */
            {
                risposta = "false";
            }
            
            /** ritorno il risultato alla pagina chiamante */
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
            
        }catch (SQLException ex) {
            /** ritorno FALSE, c'è stato un errore */
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
