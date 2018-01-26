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
 * Questa servlet viene chiamata quando, dalla pagina Pay page,
 * viene richiesto di aggiornare le informazioni relative alla carta di credito dell'utente.
 * Nel caso in cui l'utente non avesse già dei dati associati al suo profilo, verranno inseriti nel db.
 * Se invece, l'utente ha già una carta registrata, i nuovi dati sovrascriveranno quelli vecchi.
 * 
 * request variabile all'interno della quale sono memorizzati tutti i dati di cui l'utente a fatto il submit 
 * response all'interno della quale è contenuto TRUE se il salvataggio dei dati è andato a buon fine,
 *                  FALSE se si sono verificati errori 
 * @author Francesco Bruschetti
 */
public class ServletAjaxPayPageCard extends HttpServlet {


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
            /** Leggo i dati ricevuti dal client */
            String intestatarioReceived = request.getParameter("_intestatario");
            String numerocartaReceived = request.getParameter("_numerocarta");
            String meseScadenzaReceived = request.getParameter("_meseScadenza"); 
            String annoScadenzaReceived = request.getParameter("_annoScadenza"); 
            String tipoAcquistoReceived = request.getParameter("_ritiroOspedizione"); // OSS: per ora non lo mette da nessuna parte
            String userIDReceived = (request.getSession().getAttribute("userID").toString()); 

            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** controllo se l'utente ha già una carta di credito memorizzata */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id_utente FROM creditcards WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                                
                String esisteUtente = "false";
                while (results.next()) {
                    esisteUtente = results.getString(1);
                }
                
                /** Se l'utente non ha una carta di credito memorizzata */
                if(esisteUtente == "false") 
                {
                    /** ALLORA: aggiungo una nuova entry nel db, con i dati specificati */
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO creditcards(id_utente, owner, card_number, exp_month, exp_year) " + 
                                                        "VALUES (" + MyDatabaseManager.EscapeCharacters(userIDReceived) + ", " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(intestatarioReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(numerocartaReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(meseScadenzaReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(annoScadenzaReceived) + "');", connection);
                }
                else {
                
                    /** ALTRIMENTI: aggiorno i valori dell'utente (li sovrascrivo) */
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE creditcards SET " + 
                                                        "id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + " , " + 
                                                        "owner = '" + MyDatabaseManager.EscapeCharacters(intestatarioReceived) + "', " + 
                                                        "card_number = '" + MyDatabaseManager.EscapeCharacters(numerocartaReceived) + "', " + 
                                                        "exp_month = '" + MyDatabaseManager.EscapeCharacters(meseScadenzaReceived) + "', " + 
                                                        "exp_year = '" + MyDatabaseManager.EscapeCharacters(annoScadenzaReceived) + "' " +
                                                        " WHERE id_utente = "+ userIDReceived +";", connection);
                }
                risposta = "true";
                connection.close();
            }
            else  /** predispongo FALSE come risposta, c'è stato un errore */
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
