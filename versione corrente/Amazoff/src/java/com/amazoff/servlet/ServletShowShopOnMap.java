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
 * @author Francesco Bruschetti
 * 
 * Restituisce le coordinate del negozio specificato, in modo da poterlo mostrare su una mappa 
 * 
 * request contiene l'id del negozio cercato
 */
public class ServletShowShopOnMap extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try (PrintWriter out = response.getWriter()) {
            String idShop = request.getParameter("id");

            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                ResultSet results = null;
                String query = "SELECT shops.id, shops.name, shops_coordinates.lat, shops_coordinates.lng   "
                        + "FROM shops, shops_coordinates "
                        + "WHERE shops_coordinates.id_shop = shops.id "
                        + "AND shops.id = "+ idShop +";";
                
                results = MyDatabaseManager.EseguiQuery(query, connection);

                if (results.isAfterLast()) /** se non c'è un negozio che rispetta il criterio richiesto */
                {
                    /** ALLORA memorizzo l'errore, termino l'esecuzione della servlet e rimando alla pagina negoziVicini */
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noShopFound);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }

                /** ALTRIMENTI creo un oggetto json in cui memorizzo i prodotti trovati */
                boolean isFirstTime = true;
                jsonObj += "{";
                jsonObj += "\"shops\":["; 
                while (results.next()) {
                    if(!isFirstTime)            
                        jsonObj += ", ";
                    isFirstTime = false; 
                        
                    jsonObj += "{";
                    jsonObj += "\"id_shop\": \"" + results.getString(1) + "\",";
                    jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"lat\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"lng\": \"" + results.getString(4) + "\"";
                    jsonObj += "}"; 
                }
                jsonObj += "]}";
                
                

                HttpSession session = request.getSession();

                session.setAttribute("jsonNegozi", jsonObj);

                connection.close();

                response.sendRedirect(request.getContextPath() + "/negoziVicini.jsp");
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        } catch (SQLException ex) {
            response.sendRedirect(request.getContextPath() + "/"); 
        }
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
