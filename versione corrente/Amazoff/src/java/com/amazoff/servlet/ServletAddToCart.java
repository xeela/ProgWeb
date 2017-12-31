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
                            PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO cart(ID_USER, ID_PRODUCT, DATE_ADDED) VALUES ("
                                    + session.getAttribute("userID") + ", "
                                    + productReceived + ", "
                                    + "'" + MyDatabaseManager.GetCurrentDate() + "');", connection);   
                        }
                        /*else
                        {
                            //il prodotto è già nel carrello 
                        }*/
                    }                    

                    /** Dopo aver inserito il nuovo prodotto, mi faccio restituire tutta la lista di oggetti presenti nel carrello */
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT products.*,shops.*,users.first_name, users.LAST_NAME FROM cart, shops, users, products WHERE users.ID = '"+ session.getAttribute("userID") +"' and products.id = cart.ID_PRODUCT and cart.ID_USER = users.ID and products.id_shop = shops.id;", connection);
                    
                    /** dalla lista di oggetti, creo un json in cui sono memorizzati tutti i loro dati */                    
                    // -------- jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);
                   
                    /** se il carrello è vuoto */
                    if(results.isAfterLast()) 
                    {
                        /** ALLORA: genero un errore e lo memorizzo */
                        session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }

                    /** ALTRIEMTI: aggiungo i dati del prodotti ad un oggetto json */
                    boolean isFirstTime = true, isFirstTimeImg = true;
                    String id_product = "";
                    jsonObj += "{";
                    jsonObj += "\"products\":[";
                    while (results.next()) {
                        if(!isFirstTime)            //metto la virgola prima dell'oggetto solo se non è il primo
                            jsonObj += ", ";
                        isFirstTime = false;

                        id_product = results.getString(1);
                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + id_product + "\",";
                        jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                        jsonObj += "\"description\": \"" + results.getString(3) + "\",";
                        jsonObj += "\"price\": \"" + results.getString(4) + "\",";
                        jsonObj += "\"category\": \"" + results.getString(6) + "\",";
                        jsonObj += "\"ritiro\": \"" + results.getString(7) + "\",";

                        jsonObj += "\"id_shop\": \"" + results.getString(9) + "\",";
                        jsonObj += "\"shop\": \"" + results.getString(10) + "\",";
                        jsonObj += "\"description\": \"" + results.getString(11) + "\",";
                        jsonObj += "\"web_site\": \"" + results.getString(12) + "\",";
                        jsonObj += "\"id_owner\": \"" + results.getString(14) + "\",";
                        jsonObj += "\"first_name\": \"" + results.getString(16) + "\",";
                        jsonObj += "\"last_name\": \"" + results.getString(17) + "\",";


                        /** in base al prodotto, ricavo il path delle img a lui associate, così da poterci accedere dalla pagina che usa questo json */                   
                        ResultSet resultsPictures = MyDatabaseManager.EseguiQuery("SELECT id, path FROM pictures WHERE id_product = " + id_product + ";", connection);

                        /** SE non ci sono immagini per questo prodotto */
                        if(resultsPictures.isAfterLast())
                        {
                            /** ALLORA: genero e memorizzo un errore */
                            session = request.getSession();
                            session.setAttribute("errorMessage", Errors.noProductFound);
                            response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                            connection.close();
                            return;
                        }

                        /** ALTRIMENTI: memorizzo le immagini del prodotto */
                        jsonObj += "\"pictures\":[";
                        while (resultsPictures.next()) {
                            if(!isFirstTimeImg)            
                                jsonObj += ", ";
                            isFirstTimeImg = false; 

                            jsonObj += "{";
                            jsonObj += "\"id\": \"" + resultsPictures.getString(1) + "\",";
                            jsonObj += "\"path\": \"" + resultsPictures.getString(2) + "\"";
                            jsonObj += "}";
                        }
                        isFirstTimeImg = true;
                        jsonObj += "]"; // chiusura immagini prodotto
                        
                        jsonObj += "}"; // chiusura prodotto
                        
                    }
                    jsonObj += "]}";
                    
                    
                    
                    
                    connection.close();
                    session.setAttribute("shoppingCartProducts", jsonObj);
                    response.sendRedirect(request.getContextPath() + "/shopping-cartPage.jsp");
                    
                } else {
                    /** salva l'elemento selezionato nel carrello */
                    String timeStamp = new SimpleDateFormat("yyyy.MM.dd.HH.mm.ss").format(new java.util.Date());
                    Cookie cookie = new Cookie(timeStamp, productReceived);
                    cookie.setMaxAge(60 * 60 * 24 * 7);
                    response.addCookie(cookie);
                    
                    connection.close();
                    response.sendRedirect(request.getContextPath() + "/ServletShowCookieCart");
                }
                    
                
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
