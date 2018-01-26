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
 * 
 * Questa servlet restituisce tutti i dati (dettagli) relativi ad un determinato negozio
 *
 * request contiene l'id del negozio, selezionato dall'utente, di cui si vogliono visualizzare i dettagli
 * 
 * @author Francesco Bruschetti
 */
public class ServletPopulateShopPage extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
            String userReceived = request.getParameter("username"); // NULL, ma non viene mai usato
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
                /** Interrogo il db per farmi restituire i dettagli del negozio specificato */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM shops WHERE ID = " + idReceived + ";", connection);
                
                /** se non c'è il negozio specificato */
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
                    if(!isFirstTime)            /** metto la virgola prima dell'oggetto solo se non è il primo */
                        jsonObj += ", ";
                    isFirstTime = false;
                    
                    jsonObj += "{";
                    
                    jsonObj += "\"id\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"description\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"web_site\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"value\": \"" + results.getString(5) + "\",";
                    jsonObj += "\"id_owner\": \"" + results.getString(6) + "\",";
                    jsonObj += "\"business_days\": \"" + results.getString(8) + "\"";
                    jsonObj += "}";
                }
                jsonObj += "]}";
                
                HttpSession session = request.getSession();
                
                /** creo l'oggetto notifiche aggiornate, da mandare alla pagina */
                if (session.getAttribute("userID") != null) {
                    session.setAttribute("jsonNotifiche", Notifications.GetJson(session.getAttribute("userID").toString(), connection));
                } else {
                    session.setAttribute("jsonNotifiche", "{\"notifications\": []}");
                }
                
                connection.close();
                
                session.setAttribute("jsonNegozio", jsonObj);
                response.sendRedirect(request.getContextPath() + "/shopPage.jsp?id="+idReceived+""); 
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

/** in base al negozio, ricavo il path delle img a lui associate, così da poterci accedere dalla pagina che usa questo json */                   
                    //ResultSet resultsPictures = MyDatabaseManager.EseguiQuery("SELECT id, path FROM shoppictures WHERE id_shop = " + results.getString(1) + ";", connection);
                
                    /** SE non ci sono immagini per questo prodotto */
                    /**if(resultsPictures.isAfterLast())
                    {*/
                        /** ALLORA: genero e memorizzo un errore */
                    /**    HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }*/
                    
                    /** ALTRIMENTI: memorizzo le immagini del prodotto */
                    /**jsonObj += "\"pictures\":[";
                    while (resultsPictures.next()) {
                        if(!isFirstTimeImg)            
                            jsonObj += ", ";
                        isFirstTimeImg = false; 
                        
                        jsonObj += "{";
                        jsonObj += "\"id\": \"" + resultsPictures.getString(1) + "\",";
                        jsonObj += "\"path\": \"" + resultsPictures.getString(2) + "\"";
                        jsonObj += "}";
                    }*/
                    /*isFirstTimeImg = true;
                    jsonObj += "],";*/
                    
                    /** TO DO: CREARE TABELLA RECENSIONI NEGOZIO SUL DB */
                    /** Cerco nel db tutte le recensioni che sono state fatte per questo negozio */
                    //ResultSet resultsReviews = MyDatabaseManager.EseguiQuery("SELECT * FROM shop_reviews WHERE id_shop= " + results.getString(1) + ";", connection);
                
                    /** se non ci sono recensioni per questo negozio */
                    //if(resultsReviews.isAfterLast()) 
                    //{
                        /** ALLORA: genero un errore */
                   /**     HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }*/
                    
                    /** ALTRIMENTI: memorizzo le recensioni e i relativi dati (numero di stelle, testo recensione) */
                    /**float tot_avg_value = 0, num_reviews = 0;
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
                        tot_avg_value += Float.valueOf(resultsReviews.getString(2));
                    }
                    isFirstTimeImg = true;
                    jsonObj += "],";
                                        
                    jsonObj += "\"num_reviews\": \"" + num_reviews + "\",";
                    jsonObj += "\"global_value_avg\": \"" + tot_avg_value / num_reviews + "\"}";*/
