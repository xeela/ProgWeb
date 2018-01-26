package com.amazoff.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import com.amazoff.classes.Notifications;
import java.sql.Connection;

/**
 * @author Francesco Bruschetti
 * 
 * Questa servlet restituisce i dati della carta di credito e l'indirizzo associati all'utente.
 * 
 * request contiene l'id dell'utente, da usare per accedere ai rispettivi dati (carta di credito e indirizzo)
 * 
 */
public class ServletPayPage extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            String userIDReceived = session.getAttribute("userID").toString();
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            String jsonObj = "";
            float totale_carrello = 0;
            boolean isFirstTime = true;
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** restituisce i dati relativi all'indirizzo dell'utente */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM user_addresses  WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                
                /** SE non esiste un utente con quell'id */
                if(results.isAfterLast()) 
                {
                    /** ALLORA: memorizzo l'errore */
                    session.setAttribute("errorMessage", Errors.usernameDoesntExist);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }
                
                /** ALTRIMENTI: creo un oggetto json in cui memorizzari i dettagli dell'indirizzo */
                jsonObj += "{";
                jsonObj += "\"addressdata\":[";
                
                // OSS: Per ora restituisco tutto
                while (results.next()) {
                    if(isFirstTime == false) {
                        jsonObj += ",";
                    }
                    jsonObj += "{";
                    jsonObj += "\"id\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"id_utente\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"town\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"city\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"address\": \"" + results.getString(5) + "\",";
                    jsonObj += "\"province\": \"" + results.getString(6) + "\",";
                    jsonObj += "\"postal_code\": \"" + results.getString(7) + "\"";
                    jsonObj += "}";
                }
                jsonObj += "]";
                
                /** Oltre all'indirizzo, mi interessa ottenere anche i dati relativi al metodo di pagamento */
                results = MyDatabaseManager.EseguiQuery("SELECT * FROM creditcards  WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                
                /** SE non c'è un utente con quel id */
                if(results.isAfterLast()) 
                {
                    /** ALLORA: ritorno alla pagina solo il json con l'indirizzo. E memorizzo l'errore riguardo il metodo di pagamento */
                    session.setAttribute("errorMessage", Errors.usernameDoesntExist);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }
                else 
                {
                    /** ALTRIMENTI: memorizzo nell'oggetto json anche i dati relativi alla carta di credito */
                    jsonObj += ",\"paymentdata\":[";
                    isFirstTime = true;
                    while (results.next()) {
                        if(isFirstTime == false) {
                            jsonObj += ",";
                        }
                        jsonObj += "{";
                        jsonObj += "\"owner\": \"" + results.getString(3) + "\",";
                        jsonObj += "\"card_number\": \"" + results.getString(4) + "\","; 
                        jsonObj += "\"exp_month\": \"" + results.getString(5) + "\",";
                        jsonObj += "\"exp_year\": \"" + results.getString(6) + "\"";
                        jsonObj += "}";
                        isFirstTime = false;
                    }
                    jsonObj += "]";
                }
                      
                /** Estraggo dal db tutti i prodotti che l'utente ha salvato nel carrello */
                results = MyDatabaseManager.EseguiQuery("SELECT products.id, products.name, products.description, products.price, products.ritiro, cart.amount, pictures.path FROM products, cart, pictures "
                    + "WHERE cart.ID_USER = " + session.getAttribute("userID") + " AND cart.ID_PRODUCT = products.ID AND pictures.ID_PRODUCT = products.ID  ORDER BY products.RITIRO DESC;", connection);
                
                /** Inserisco i prodotti nel json */
                jsonObj += ",\"products\":[";
                isFirstTime = true;
                int amount = 0;
                float price = 0;
                while (results.next()) {
                        if(!isFirstTime)            
                            jsonObj += ", ";
                        isFirstTime = false;
                        
                        price = Float.parseFloat(results.getString(4));
                        amount = Integer.parseInt(results.getString(6));
                        totale_carrello += (price * amount);
                                
                        jsonObj += "{";
                        jsonObj += "\"id_product\": \"" + results.getString(1) + "\","; 
                        jsonObj += "\"name\": \"" + results.getString(2) + "\",";  
                        jsonObj += "\"description\": \"" + results.getString(3) + "\","; 
                        jsonObj += "\"ritiro\": \"" + results.getString(5) + "\","; 
                        jsonObj += "\"path\": \"" + results.getString(7) + "\","; 
                        jsonObj += "\"price\": \"" + price + "\",";
                        jsonObj += "\"amount\": \"" + amount + "\",";
                        jsonObj += "\"tot\": \"" + (price * amount) + "\"";
                        jsonObj += "}";
                    }
                
                jsonObj += "],";
                jsonObj += "totCart: \""+ totale_carrello +"\"}";
                
                /** memorizzo i dati in unsa sessione, cosi da visualizzarli come riepilogo ordine, in PayPage */
                session.setAttribute("jsonPayPage", jsonObj);  
                
                /** Memorizzo l'oggetto json in una variabile di sessione da cui recuperare i dati per visualizzarli prima di completare l'acquisto */
                session.setAttribute("shoppingCartProducts", jsonObj);
                
                /** creo l'oggetto notifiche aggiornate, da mandare alla pagina */
                if (session.getAttribute("userID") != null) {
                    session.setAttribute("jsonNotifiche", Notifications.GetJson(session.getAttribute("userID").toString(), connection));
                } else {
                    session.setAttribute("jsonNotifiche", "{\"notifications\": []}");
                }
                
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/payPage.jsp");       
            }
            else
            {
                /** C'è stato un errore dovuto alla connessione con il db */
                response.sendRedirect(request.getContextPath() + "/payPage"); 
            }
        }catch (SQLException ex) {
            /** Errore generico non previsto */
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletPayPage", ex.toString());
            HttpSession session = request.getSession();
            response.sendRedirect(request.getContextPath() + "/payPage"); 
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
