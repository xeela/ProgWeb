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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Francesco Bruschetti
 */
public class ServletPopulateProductPage extends HttpServlet {

    /**
     * ServletPopulateProductPage
     * 
     * Questa servlet restituisce tutti i dati (dettagli) relativi ad un determinato prodotto
     *
     * @param request contiene l'id del prodotto, selezionato dall'utente, di cui si vogliono visualizzare i dettagli
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            String idReceived = request.getParameter("id");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            String jsonObj = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** Interrogo il Db per farmi restituire i dettagli del prodotto specificato */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM products, shops, users WHERE products.ID = " + idReceived + " and products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER;", connection);
                
                /** se non c'è il prodotto specificato */
                if(results.isAfterLast()) 
                {
                    /** ALLORA: genero un errore e lo memorizzo */
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noProductFound);
                    response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                    connection.close();
                    return;
                }
                               
                /** ALTRIEMTI: aggiungo i dati del prodotti ad un oggetto json */
                boolean isFirstTime = true, isFirstTimeImg = true, isFirstReview = true;
                jsonObj += "{";
                jsonObj += "\"result\":[";
                while (results.next()) {
                    
                    if(!isFirstTime)            //metto la virgola prima dell'oggetto solo se non è il primo
                        jsonObj += ", ";
                    isFirstTime = false;
                    
                    jsonObj += "{";
                    jsonObj += "\"id\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"description\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"price\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"category\": \"" + results.getString(6) + "\",";
                    jsonObj += "\"ritiro\": \"" + results.getString(7) + "\",";
                    
                    jsonObj += "\"id_shop\": \"" + results.getString(10) + "\",";
                    jsonObj += "\"shop\": \"" + results.getString(11) + "\",";
                    jsonObj += "\"description\": \"" + results.getString(12) + "\",";
                    jsonObj += "\"web_site\": \"" + results.getString(13) + "\",";
                    jsonObj += "\"id_owner\": \"" + results.getString(15) + "\",";
                    jsonObj += "\"first_name\": \"" + results.getString(19) + "\",";
                    jsonObj += "\"last_name\": \"" + results.getString(20) + "\",";
                    
                    
                    /** in base al prodotto, ricavo il path delle img a lui associate, così da poterci accedere dalla pagina che usa questo json */                   
                    ResultSet resultsPictures = MyDatabaseManager.EseguiQuery("SELECT id, path FROM pictures WHERE id_product = " + results.getString(1) + ";", connection);
                
                    /** SE non ci sono immagini per questo prodotto */
                    if(resultsPictures.isAfterLast())
                    {
                        /** ALLORA: genero e memorizzo un errore */
                        HttpSession session = request.getSession();
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
                    jsonObj += "],";
                    
                    
                    /** Cerco nel db tutte le recensioni che sono state fatte per questo oggetto */
                    ResultSet resultsReviews = MyDatabaseManager.EseguiQuery("SELECT * FROM reviews WHERE id_product = " + results.getString(1) + ";", connection);
                
                    /** se non ci sono recensione per questo prodotto */
                    if(resultsReviews.isAfterLast()) 
                    {
                        /** ALLORA: genero un errore */
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }
                    
                    /** ALTRIMENTI: memorizzo le recensioni e i relativi dati (numero di stelle, testo recensione) */
                    float tot_reviews_value = 0, num_reviews = 0, global_value_avg = 0;
                    jsonObj += "\"reviews\":[";
                    while (resultsReviews.next()) {
                        num_reviews += 1;
                        if(!isFirstReview)            
                            jsonObj += ", ";
                        isFirstReview = false; 
                        
                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + resultsReviews.getString(1) + "\",";
                        jsonObj += "\"global_value\": \"" + resultsReviews.getString(2) + "\",";
                        jsonObj += "\"quality\": \"" + resultsReviews.getString(3) + "\",";
                        jsonObj += "\"service\": \"" + resultsReviews.getString(4) + "\",";
                        jsonObj += "\"value_for_money\": \"" + resultsReviews.getString(5) + "\",";
                        jsonObj += "\"name\": \"" + resultsReviews.getString(6) + "\",";
                        jsonObj += "\"description\": \"" + resultsReviews.getString(7) + "\",";
                        jsonObj += "\"date_creation\": \"" + resultsReviews.getString(8) + "\",";
                        jsonObj += "\"id_creator\": \"" + resultsReviews.getString(10) + "\"";
                        jsonObj += "}";
                        tot_reviews_value += Float.valueOf(resultsReviews.getString(2));
                    }
                    isFirstTimeImg = true;
                    jsonObj += "],";
                                        
                    jsonObj += "\"num_reviews\": \"" + num_reviews + "\",";
                    if(num_reviews > 0){
                        global_value_avg = (tot_reviews_value / num_reviews);
                    }
                    jsonObj += "\"global_value_avg\": \"" + global_value_avg + "\"}";
                }
                jsonObj += "]}";
                
                HttpSession session = request.getSession();
                
                // creo l'oggetto notifiche aggiornate, da mandare alla pagina
                if (session.getAttribute("userID") != null) {
                    session.setAttribute("jsonNotifiche", Notifications.GetJson(session.getAttribute("userID").toString(), connection));
                } else {
                    session.setAttribute("jsonNotifiche", "{\"notifications\": []}");
                }
                
                connection.close();
                
                session.setAttribute("jsonProdotti", jsonObj);
                response.sendRedirect(request.getContextPath() + "/productPage.jsp?id="+idReceived+""); 
            }
            else
            {
                HttpSession session = request.getSession();
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
    }

}
