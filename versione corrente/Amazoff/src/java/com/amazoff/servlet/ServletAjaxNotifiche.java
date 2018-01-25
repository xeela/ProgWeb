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
 * @author Francesco Bruschetti
 */
public class ServletAjaxNotifiche extends HttpServlet {

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
     * Questa servlet, riceve l'id di una notifica e lo utilizza per settarne lo stato, nel db, come "LETTA"
     * 
     * @param request variabile all'interno della quale è contenuto l'id della notificha di cui si richiedono maggiori dettagli
     * @return response all'interno della quale è contenuto TRUE se l'operazione è stata completata correttamente
     *                  FALSE se si sono verificati errori  
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String risposta = "-1";
        try (PrintWriter out = response.getWriter()) {
            
            String idNotifica = request.getParameter("idNotification");

            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                 
                /** se ho ricevuto un idNotifica "valido", modifico il suo stato nel db, impostando la notifica come LETTA */
                if(idNotifica != null){
                    MyDatabaseManager.EseguiStatement("UPDATE notifications SET already_read = 1 WHERE id = " + idNotifica + ";", connection);
                    risposta = "true";
                }
                else 
                    risposta = "false";
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
