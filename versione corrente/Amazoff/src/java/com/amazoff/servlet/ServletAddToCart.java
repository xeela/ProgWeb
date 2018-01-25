package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author Davide Farina
 */
public class ServletAddToCart extends HttpServlet {

    /**
     * Servlet che permette di memorizzare un prodotto, nel carrello dell'utente, che lo ha richiesto.
     * 
     * @param request contiene l'id dell'oggeto che l'utente vuole aggiungere nel carrello
     * @param session contiene l'id dell'utente registrato che sta richiedendo l'operazione
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            
            /** Leggo i dati ricevuti dal client */
            String productReceived = request.getParameter("productID");
            String requested = request.getParameter("requested");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (session.getAttribute("user") != null) {
                    /** Se sto aggiungendo un prodotto lo aggiungo, altrimenti vado solo alla pagina del carrello senza aggiungere nulla */
                    if(productReceived != null)
                    {
                        /** Controllo se il prodotto è già presente nel carrello dell'utente. Se si, non faccio nulla, altrimenti lo aggiungo */
                        ResultSet isPresent = MyDatabaseManager.EseguiQuery("SELECT * FROM cart WHERE ID_USER = " + session.getAttribute("userID") + " AND ID_PRODUCT = " + productReceived + ";", connection);
                        /** Se non c'è */
                        if(!isPresent.isBeforeFirst())
                        {
                            /** Interrogo il db per inserire nel carrello dell'utente, l'id del prodotto specificato */
                            PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO cart(ID_USER, ID_PRODUCT, DATE_ADDED, AMOUNT) VALUES ("
                                    + session.getAttribute("userID") + ", "
                                    + productReceived + ", "
                                    + "'" + MyDatabaseManager.GetCurrentDate() + "',"
                                    + requested + ");", connection);   
                        }
                        /*else
                        {
                            //il prodotto è già nel carrello 
                        }*/
                    }                    
                    
                    
                } else { 
                    /** L'utente NON ha effettuato il login. 
                     * Quindi salvo l'elemento selezionato in un cookie
                     */
                    Cookie cookie = new Cookie(productReceived, productReceived);
                    cookie.setMaxAge(60 * 60 * 24 * 7);
                    response.addCookie(cookie);
                }
                    
                connection.close();
                response.sendRedirect(request.getContextPath() + "/ServletShowCart");
                
            } else {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        } catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletAddToCart", ex.toString());
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/"); 
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
