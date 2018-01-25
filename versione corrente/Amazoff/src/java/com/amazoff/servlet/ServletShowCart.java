package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import com.amazoff.classes.Notifications;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Recupera i dati dei prodotti inseriti nel carrello per utenti non loggati.
 *
 * @author Caterina Battisti
 */
public class ServletShowCart extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            String jsonObj = "";
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
            
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                if (session.getAttribute("userID") != null) {
                    /** Dopo aver inserito il nuovo prodotto, mi faccio restituire tutta la lista di oggetti presenti nel carrello */
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT products.*,shops.*,users.first_name, users.LAST_NAME, cart.amount FROM cart, shops, users, products WHERE users.ID = "+ session.getAttribute("userID") +" and products.id = cart.ID_PRODUCT and cart.ID_USER = users.ID and products.id_shop = shops.id;", connection);
                    
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
                        if(!isFirstTime)            /** metto la virgola prima dell'oggetto solo se non è il primo */
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
                        jsonObj += "\"quantita\": \"" + results.getString(20) + "\",";

                        jsonObj += "\"id_shop\": \"" + results.getString(10) + "\",";
                        jsonObj += "\"shop\": \"" + results.getString(11) + "\",";
                        jsonObj += "\"description\": \"" + results.getString(12) + "\",";
                        jsonObj += "\"web_site\": \"" + results.getString(13) + "\",";
                        jsonObj += "\"id_owner\": \"" + results.getString(15) + "\",";
                        jsonObj += "\"first_name\": \"" + results.getString(18) + "\",";
                        jsonObj += "\"last_name\": \"" + results.getString(19) + "\",";


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

                } else {          
                    /** Se l'utente non è loggato, estraggo i dati del carrello, dai cookie */
                    Cookie[] cart = request.getCookies();
                    if (cart != null) {                        
                        ResultSet results, resultsPictures = null;
                        String value;
                        boolean isFirstTime = true, isFirstTimeImg = true;
                        
                        jsonObj += "{";
                        jsonObj += "\"products\":[";
                        
                        for (int i = 0; i < cart.length-1; i++) {
                            if(!isFirstTime)            /** metto la virgola prima dell'oggetto solo se non è il primo */
                                jsonObj += ", ";
                            isFirstTime = false;
                            
                            value = cart[i].getValue();
                            
                            results = MyDatabaseManager.EseguiQuery("SELECT products.*, shops.* FROM shops, products WHERE products.id_shop = shops.id and products.id = " + value + ";", connection);
                            
                            results.next();
                            
                            jsonObj += "{";
                            jsonObj += "\"id\": \"" + value + "\",";
                            jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                            jsonObj += "\"description\": \"" + results.getString(3) + "\",";
                            jsonObj += "\"price\": \"" + results.getString(4) + "\",";
                            jsonObj += "\"category\": \"" + results.getString(6) + "\",";
                            jsonObj += "\"ritiro\": \"" + results.getString(7) + "\",";

                            jsonObj += "\"id_shop\": \"" + results.getString(10) + "\",";
                            jsonObj += "\"shop\": \"" + results.getString(11) + "\",";
                            jsonObj += "\"description\": \"" + results.getString(12) + "\",";
                            jsonObj += "\"web_site\": \"" + results.getString(13) + "\",";
                            
                            /** in base al prodotto, ricavo il path delle img a lui associate, così da poterci accedere dalla pagina che usa questo json */                   
                            resultsPictures = MyDatabaseManager.EseguiQuery("SELECT id, path FROM pictures WHERE id_product = " + value + ";", connection);

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
                    }
                }
                                
                if (session.getAttribute("userID") != null) {
                    session.setAttribute("jsonNotifiche", Notifications.GetJson(session.getAttribute("userID").toString(), connection));
                } else {
                    session.setAttribute("jsonNotifiche", "{\"notifications\": []}");
                }
                
                connection.close();
                session.setAttribute("shoppingCartProducts", jsonObj);
                response.sendRedirect(request.getContextPath() + "/shopping-cartPage.jsp");
                                
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
