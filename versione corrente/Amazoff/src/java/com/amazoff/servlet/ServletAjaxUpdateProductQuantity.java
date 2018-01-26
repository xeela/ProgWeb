package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.Integer.parseInt;
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
 * Questa servlet si occupa di modificare la quantità richiesta, per un determinato prodotto, da un determinato utente, nella pagina di gestione del carrello
 * @author Davide Farina
 */
public class ServletAjaxUpdateProductQuantity extends HttpServlet {

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
        String jsonObj = "";
        HttpSession session;
        try (PrintWriter out = response.getWriter()) {
            session = request.getSession();
            /** leggo i dati ricevuti dal client */
            String idProductReceived = request.getParameter("_idProdotto");
            String idUser = session.getAttribute("userID").toString();
            String addOrRemove = request.getParameter("_whatToDo");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
    
                if(addOrRemove.equals("add"))
                {
                    int available = 0, requested = 0;
                    /** ottengo dal db, dati riguardanti il prodotto specificato dall'utente */
                    ResultSet results =  MyDatabaseManager.EseguiQuery("SELECT products.AVAILABLE, cart.AMOUNT FROM cart, products WHERE cart.id_product = products.id and cart.id_user = " + idUser + " and products.id = " + idProductReceived + ";", connection);
                    while (results.next()) {
                        available = parseInt(results.getString(1));
                        requested = parseInt(results.getString(2));
                    }
                    /** Prima di aumentare la quantità del prodotto, controllo che c'è ne sia un numero sufficiente nel db */
                    if(requested + 1 <= available)
                    {
                        MyDatabaseManager.EseguiStatement("UPDATE cart SET amount = amount + 1 WHERE id_user = " + idUser + " AND id_product = " + idProductReceived + ";", connection);
                        risposta = "true";
                    }
                    else
                        risposta = "false";
                }
                else if(addOrRemove.equals("remove"))
                {
                    int requested = 0;
                    ResultSet results =  MyDatabaseManager.EseguiQuery("SELECT cart.AMOUNT FROM cart WHERE cart.id_user = " + idUser + " and cart.id_product = " + idProductReceived + ";", connection);
                    while (results.next()) {
                        requested = parseInt(results.getString(1));
                    }
                    /** L'utente può diminuire la quantità del prodotto, ma questa non può mai scendere sotto 1 */
                    if(requested - 1 > 0)
                    {
                        MyDatabaseManager.EseguiStatement("UPDATE cart SET amount = amount - 1 WHERE id_user = " + idUser + " AND id_product = " + idProductReceived + ";", connection);
                        risposta = "true";
                    }
                    else
                        risposta = "false";

                }
                else
                {
                    risposta = "false";
                }

                /** dopo aver cambiato la quantità, aggiorno la lista json dei prodotti nel carrello */
                if(risposta.equals("true"))
                {
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT products.*,shops.*,users.first_name, users.LAST_NAME, cart.amount FROM cart, shops, users, products WHERE users.ID = '"+ idUser +"' and products.id = cart.ID_PRODUCT and cart.ID_USER = users.ID and products.id_shop = shops.id;", connection);
                    
                    /** se non c'è il prodotto specificato */
                    if(results.isAfterLast()) 
                    {
                        /** ALLORA: genero un errore e lo memorizzo */
                        session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/");
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
                
                    session.setAttribute("shoppingCartProducts", jsonObj);
                }
                
                risposta += "$"+ jsonObj;
                connection.close();
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
