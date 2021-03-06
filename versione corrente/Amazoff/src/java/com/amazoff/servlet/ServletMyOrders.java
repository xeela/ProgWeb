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
 * Recupera i dati di tutti gli ordini effettuati dall'utente loggato.
 *
 * @author Caterina Battisti
 */

public class ServletMyOrders extends HttpServlet {

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
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (session.getAttribute("userID") != null) {
                    // recupera gli ordini
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT orders.*, products.*, owner.*, shops.* "
                            + "FROM orders, users AS user, users AS owner, orders_products, products, shops "
                            + "WHERE user.ID = " + session.getAttribute("userID") + " AND orders.who_ordered = user.id AND "
                            + "orders_products.order_id = orders.id AND products.id = orders_products.product_id AND "
                            + "products.id_shop = shops.id AND shops.ID_OWNER = owner.id "
                            + "ORDER BY orders.id DESC;", connection);

                    if (results.isBeforeFirst() ) {
                        boolean isFirstTime = true, isFirstTimeImg = true, isFirstTimeProduct = true;
                        String current_id = "-1";
                        String id_product, id_order;
                        jsonObj += "{";
                        jsonObj += "\"orders\":[";
                        while (results.next()) {       
                            isFirstTimeImg = true;
                            id_order = results.getString(1);
                            id_product = results.getString(5);

                            if(!id_order.equals(current_id)){
                                if(!isFirstTimeProduct)
                                    jsonObj += "]}, ";
                                isFirstTimeProduct = false;

                                jsonObj += "{";
                                jsonObj += "\"products\":[";
                            } else{
                                    jsonObj += ", ";
                            }
                            current_id = id_order;

                            jsonObj += "{";
                            jsonObj += "\"order_id\": \"" + id_order + "\",";
                            jsonObj += "\"order_date\": \"" + results.getString(3) + "\",";
                            jsonObj += "\"product_id\": \"" + id_product + "\",";                    
                            jsonObj += "\"name\": \"" + results.getString(6) + "\",";
                            jsonObj += "\"description\": \"" + results.getString(7) + "\",";
                            jsonObj += "\"price\": \"" + results.getString(8) + "\",";
                            jsonObj += "\"id_shop\": \"" + results.getString(9) + "\",";
                            jsonObj += "\"category\": \"" + results.getString(10) + "\",";
                            jsonObj += "\"ritiro\": \"" + results.getString(11) + "\",";
                            jsonObj += "\"last_name\": \"" + results.getString(16) + "\","; /* dati del venditore */
                            jsonObj += "\"first_name\": \"" + results.getString(15) + "\",";
                            jsonObj += "\"shop_name\": \"" + results.getString(24) + "\",";
                            jsonObj += "\"site_url\": \"" + results.getString(26) + "\",";
                            jsonObj += "\"num_reviews\": \"" + results.getString(27) + "\",";

                            // richiedo le immagini per questo prodotto
                            jsonObj += "\"pictures\": [";
                            ResultSet resultsImages = MyDatabaseManager.EseguiQuery("SELECT path FROM pictures WHERE ID_PRODUCT = "+id_product+";", connection);

                            while (resultsImages.next()) {
                                if(!isFirstTimeImg)            
                                    jsonObj += ", ";
                                isFirstTimeImg = false;
                                jsonObj += "{";
                                jsonObj += "\"path\": \"" + resultsImages.getString(1) + "\"";                            
                                jsonObj += "}";
                            }

                            jsonObj += "]"; // chiusura array images

                            jsonObj += "}"; // chiusura dati ordine
                        }
                        jsonObj += "]}";    // chiusura ordine
                    } else {
                        jsonObj = "{'orders': [{'products': [{'order_id': 'empty'}]}";
                    }
                    jsonObj += "]}";
                }
                
                /** controllo se la pagina degli ordini è stata chiamata da una notifica. */                
                if(request.getParameter("notificationId") != null)
                {
                    String idNotifica = request.getParameter("notificationId").toString();
                    /** aggiorno il valore della notifica e lo metto a "LETTA" */
                    MyDatabaseManager.EseguiStatement("UPDATE notifications SET already_read = 1 WHERE ID = " + idNotifica +";", connection);
                }
                                
                connection.close();

                session.setAttribute("jsonProdotti", jsonObj);
                
                if(request.getParameter("id") != null)
                    response.sendRedirect(request.getContextPath() + "/myOrders.jsp#"+request.getParameter("id")); 
                else
                    response.sendRedirect(request.getContextPath() + "/myOrders.jsp");
            }            
            else
            {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        }catch (SQLException ex) {
            HttpSession session = request.getSession();
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
    }// </editor-fold>

}
