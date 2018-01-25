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
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author Gianluca Pasqua
 */
public class ServletAjaxCarrello extends HttpServlet {

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

    /**
     * Questa servlet, riceve l'id di un utente e quello del prodotto che è stato selezionato per essere rimosso dal carrello
     * 
     * @param request variabile all'interno della quale è contenuto l'id del prodotto da rimuovere dal carrello
     *                  e quello dell'utente che ha richiesto l'operazione
     * @return response all'interno della quale è contenuto TRUE se l'operazione è stata completata correttamente
     *                  FALSE se si sono verificati errori  
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String risposta = "-1";
        String jsonObj = "";
        HttpSession session;
        try (PrintWriter out = response.getWriter()) {
            
            session = request.getSession();
            
            /** Leggo i parametri ricevuti dal client */
            String idProductReceived = request.getParameter("_idProdotto");
            String idUser = request.getParameter("_idUser");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
    
                /** Elimino l'elemento specificato (idProductReceived), dal carrello dell'utente (idUser) */
                PreparedStatement result = MyDatabaseManager.EseguiStatement("DELETE FROM cart WHERE id_user = "+ idUser +"  AND  id_product = " + MyDatabaseManager.EscapeCharacters(idProductReceived)+ ";", connection);
                
                risposta = "true";
                
                /** dopo aver rimosso il prodotto, aggiorno la lista json dei prodotti nel carrello */
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


                    /** in base al prodotto, ricavo il path del' immagine a lui associata, così da poterci accedere dalla pagina che usa questo json */                   
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
                    jsonObj += "]"; /** chiusura immagini prodotto */
                    jsonObj += "}"; /** chiusura prodotto */
                        
                }
                jsonObj += "]}"; /** chiusura file json */
                
            session.setAttribute("shoppingCartProducts", jsonObj);
            risposta += "$"+ jsonObj;
            connection.close();
            }
            else  /** predispongo FALSE come risposta, c'è stato un errore */
            {
                risposta = "false";
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
