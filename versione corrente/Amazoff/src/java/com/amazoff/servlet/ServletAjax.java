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
 * 
 * Questa servlet viene chiamata dalla pagina loginpage quando un utente si sta registrando.
 * Ha il compito di verificare che il valore ricevuto (email o username) non sia già presenti nel db.
 * 
 * request può contenere il dato EMAIL o USERNAME, in base all'operazione che deve eseguire.
 *                L'operazione che svolge è specificata nella variabile "OP"
 * response all'interno della quale è contenuto TRUE se il valore in ingresso è univoco nel db
 *                  FALSE se è già presente o se si sono verificati errori           
 * @author Francesco
 */
public class ServletAjax extends HttpServlet {

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
            
            /** Leggo i dati ricevuti dal client */
            String operazione = request.getParameter("op");
            String emailReceived = request.getParameter("_email");
            String usernameReceived = request.getParameter("_user");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** in base al tipo di operazione richiesta, controllo se il parametro ricevuto è una email o un username univoco */
                switch(operazione) {
                    case "email":
                        results = MyDatabaseManager.EseguiQuery("SELECT email FROM users WHERE email = '" + MyDatabaseManager.EscapeCharacters(emailReceived) + "';", connection);
                        break;
                    default: results = MyDatabaseManager.EseguiQuery("SELECT username FROM users WHERE username = '" + MyDatabaseManager.EscapeCharacters(usernameReceived) + "';", connection);
                        break;
                }

                if(results.isAfterLast()) //NON SO QUANDO CI ENTRA. se non c'è un utente con quel nome --> ritorno TRUE
                {
                    risposta = "true";
                }
                else {
                    risposta = "true";
                    while (results.next()) { /** se esiste un utente con quella email/username, predispongo FALSE come risposta. Non devo avere due persone con la stessa email */
                        risposta = "false";
                    }
                }
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
