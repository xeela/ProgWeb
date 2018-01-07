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
 *
 * @author Francesco Bruschetti
 */
public class ServletPayPage extends HttpServlet {

    /**
     * 
     * ServletPayPage
     * 
     * Questa servlet restituisce i dati della carta di credito e l'indirizzo associati all'utente.
     * 
     * @param request contiene l'id dell'utente, da usare per accedere ai rispettivi dati (carta di credito e indirizzo)
     * 
     */
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
            boolean isFirstTime = true;
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** restituisce i dati relativi all'indirizzo dell'utente */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM user_addresses  WHERE id_utente = " + MyDatabaseManager.EscapeCharacters(userIDReceived) + ";", connection);
                
                /** SE non esiste un utente con quell'id */
                if(results.isAfterLast()) 
                {
                    /** ALLORA: memorizzo l'errore in modo da poterlo mostrare all'utente */
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
                    /** ALLORA: ritorno alla pagina solo il json con l'indirizzo. E l'errore riguardo il metodo di pagamento */
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
                    // OSS: Per ora restituisco tutto
                    while (results.next()) {
                        if(isFirstTime == false) {
                            jsonObj += ",";
                        }
                        jsonObj += "{";
                        jsonObj += "\"owner\": \"" + results.getString(3) + "\",";
                        jsonObj += "\"card_number\": \"" + results.getString(4) + "\","; // TO DO: ritornare una stringa di N asterischi e solo le ultime 2 cifre visibili
                        jsonObj += "\"exp_month\": \"" + results.getString(5) + "\",";
                        jsonObj += "\"exp_year\": \"" + results.getString(6) + "\"";
                        jsonObj += "}";
                        isFirstTime = false;
                    }
                    jsonObj += "]";
                }
                jsonObj += "}";
                
                
                session.setAttribute("jsonPayPage", jsonObj);  
                
                /** Estraggo dal db tutti i prodotti che l'utente ha salvato nel carrello */
                results = MyDatabaseManager.EseguiQuery("SELECT products.id, name, description, price FROM products, cart "
                    + "WHERE ID_USER = " + session.getAttribute("userID") + " AND ID_PRODUCT = products.ID;", connection);
                
                /** Inserisco i prodotti nel json */
                jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);
                
                /** Memorizzo l'oggetto json in una variabile di sessione da cui recuperare i dati per visualizzarli prima di completare l'acquisto */
                session.setAttribute("shoppingCartProducts", jsonObj);
                
                // creo l'oggetto notifiche aggiornate, da mandare alla pagina
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
                /** In caso di errore dovuto alla connessione, lo memorizzo, così da poterlo comunicare all'utente nella pagina corretta */
                //session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/payPage"); 
            }
        }catch (SQLException ex) {
            /** In caso di errore generico non previsto, lo memorizzo, così da poterlo comunicare all'utente nella pagina corretta */
            
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletPayPage", ex.toString());
            HttpSession session = request.getSession();
            //session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/payPage"); 
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
