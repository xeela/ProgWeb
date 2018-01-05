package com.amazoff.servlet;

import com.amazoff.classes.Errors;
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
import javax.servlet.http.HttpSession;
/**
 *
 * @author Francesco Bruschetti
 */
public class SerlvetAjaxGetNotifications extends HttpServlet {

    /**
     * Servlet che restituisce tutte le notifiche dell'utente loggato
     * 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String jsonObj = "";

        HttpSession session = request.getSession();
        
        try (PrintWriter out = response.getWriter()) {
            
            
            String idUser = request.getParameter("_idUser");

            if(idUser != null) 
            {
                /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
                if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
                {
                    MyDatabaseManager mydb = new MyDatabaseManager();
                }

                if(MyDatabaseManager.cpds != null)
                {
                    Connection connection = MyDatabaseManager.CreateConnection();
                        
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM notifications WHERE ID_USER = "+idUser+";", connection);
                
                    if (results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
                    {
                        session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }
                    
                    boolean isFirstTime = true;
                    jsonObj += "{";
                    jsonObj += "\"notifications\":["; 
                    while (results.next()) {
                        if(!isFirstTime)            
                            jsonObj += ", ";
                        isFirstTime = false; 

                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + results.getString(1) + "\",";
                        jsonObj += "\"id_user\": \"" + results.getString(2) + "\",";
                        jsonObj += "\"type\": \"" + results.getString(3) + "\",";
                        jsonObj += "\"description\": \"" + results.getString(4) + "\",";
                        jsonObj += "\"date_added\": \"" + results.getString(5) + "\",";
                        jsonObj += "\"link\": \"" + results.getString(6) + "\",";
                        jsonObj += "\"already_read\": \"" + results.getString(7) + "\"";
                        jsonObj += "}"; //chiusura notifica
                    }
                    jsonObj += "]}";
                    
                    connection.close();
                } 
                else /** problemi di connessione con il db */
                {
                    jsonObj = "{ notifications: [] }";
                }
            }
            else /** id_user is null */
            {
                jsonObj = "{ notifications: [] }";
            }
            
            
            session.setAttribute("jsonNotifiche", jsonObj);
            
            response.setContentType("text/plain");
            response.getWriter().write(jsonObj); // ritorno alla pagina l'oggetto jsonObj: serve quando la index chiede le notifiche, serve per evitare crash se l'utente non è loggato
            
        }catch (SQLException ex) { /** Gestione di errori non previsti */
            /** ritorno json vuoto se c'è stato un errore */
            jsonObj = "{ notifications: [] }";
            
             session.setAttribute("jsonNotifiche", jsonObj);
            
            response.setContentType("text/plain");
            response.getWriter().write(jsonObj);
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
        processRequest(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
