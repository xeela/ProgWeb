/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Davide Farina
 */
public class ServletAddToCart extends HttpServlet {

    /**
     * Servlet che permette di memorizzare un prodotto, nel carrello dell'utente, registrato, che lo ha richiesto.
     * 
     * @param request contiene l'id dell'oggeto che l'utente vuole aggiungere nel carrello
     * @param session contiene l'id dell'utente registrato che sta richiedendo l'operazione
     * 
     * @return response all'interno della quale è contenuto TRUE se l'oggetto è stato memorizzato correttamente nel carrello dell'utente
     *                  FALSE se si sono verificati errori  
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            String productReceived = request.getParameter("productID");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (session.getAttribute("user") != null) {
                    //Se sto aggiungendo un prodotto lo aggiungo, altrimenti vado solo alla pagina del carrello senza aggiungere nulla
                    if(productReceived != null)
                    {
                        /** Controllo se il prodotto è già presente nel carrello dell'utente. Se si, non faccio nulla, altrimenti lo aggiungo*/
                        ResultSet isPresent = MyDatabaseManager.EseguiQuery("SELECT * FROM cart WHERE ID_USER = " + session.getAttribute("userID") + " AND ID_PRODUCT = " + productReceived + ";", connection);
                        //Se non c'è
                        if(!isPresent.isBeforeFirst())
                        {
                            /** Interrogo il per inserire nel carrello dell'utente, l'id del prodotto specificato */
                            PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO cart(ID_USER, ID_PRODUCT, DATE_ADDED, AMOUNT) VALUES ("
                                    + session.getAttribute("userID") + ", "
                                    + productReceived + ", "
                                    + "'" + MyDatabaseManager.GetCurrentDate() + "',"
                                    + " 1);", connection);   
                        }
                        /*else
                        {
                            //il prodotto è già nel carrello 
                        }*/
                    }                    
                    
                    
                } else {
                    /** salva l'elemento selezionato nel carrello */
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
