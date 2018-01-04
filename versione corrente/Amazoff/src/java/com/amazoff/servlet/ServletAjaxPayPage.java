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
 * @author Francesco
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

    /**
     * 
     * Questa servlet viene chiamata quando, dalla pagina  PayPage,
     * viene richiesto di aggiornare le informazioni relative all'indirizzo di spedizione per i prodotti che l'utente sta per comprare
     * Nel caso in cui l'utente non avesse già un indirizzo associato al suo profilo, verrà memorizzato quello nuovo.
     * Se invece, l'utente ha già un indirizzo, i nuovi dati sovrascriveranno quelli vecchi
     * 
     * @param request variabile all'interno della quale sono memorizzati tutti i dati di cui l'utente a fatto il submit 
     * @return response all'interno della quale è contenuto TRUE se il salvataggio dei dati è andato a buon fine,
     *                  FALSE se si sono verificati errori   
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String risposta = "-1";
        try (PrintWriter out = response.getWriter()) {
            
            String paeseReceived = request.getParameter("_paese");
            String indirizzoReceived = request.getParameter("_indirizzo");
            String cittaReceived = request.getParameter("_citta");
            String provinciaReceived = request.getParameter("_provincia");
            String capReceived = request.getParameter("_cap");
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
                /** ottengo dal db i dati dell'indirizzo dell'utente con @param id specificato */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id_utente FROM user_addresses WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                                
                String esisteUtente = "false";
                while (results.next()) { 
                    esisteUtente = results.getString(1);
                }
                
                /** Se l'utente NON esiste (quindi non ha un indirizzo associato */
                if(esisteUtente == "false") 
                {
                    /** ALLORA: aggiungo un nuovo campo nel db con i dati ricevuti dalla pagina PayPage */
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO user_addresses(id_utente, town, city, address, province, postal_code) " + 
                                                        "VALUES (" + MyDatabaseManager.EscapeCharacters(userIDReceived) + ", " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(paeseReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(indirizzoReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(cittaReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(provinciaReceived) + "', " + MyDatabaseManager.EscapeCharacters(capReceived) + ");", connection);
                }
                else {
                
                    /** ALTRIMENTI: aggiorno i valori dell'utente (li sovrascrivo) */
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE user_addresses SET " + 
                                                        "id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + " , " + 
                                                        "town = '" + MyDatabaseManager.EscapeCharacters(paeseReceived) + "', " + 
                                                        "city = '" + MyDatabaseManager.EscapeCharacters(indirizzoReceived) + "', " + 
                                                        "address = '" + MyDatabaseManager.EscapeCharacters(cittaReceived) + "', " + 
                                                        "province = '" + MyDatabaseManager.EscapeCharacters(provinciaReceived) + "', " +
                                                        "postal_code = " + MyDatabaseManager.EscapeCharacters(capReceived) + 
                                                        " WHERE id_utente = "+ userIDReceived +";", connection);
                }
                /** @return "true" ritorno al client un valore di OK, l'inserimento dei dati è avvenuto correttamente  */
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
            /** @return "true" ritorno al client un valore di OK, l'inserimento dei dati è avvenuto correttamente  */
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
