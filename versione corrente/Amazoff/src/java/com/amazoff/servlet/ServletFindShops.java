package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * In base alla posizione dell'utente (latitudine e longitudine), estrae dal database
 * i negozi nelle vicinanze dell'utente.
 * 
 * @author Caterina Battisti
 */
@WebServlet(name = "ServletFindShops", urlPatterns = {"/ServletFindShops"})
public class ServletFindShops extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userLat = request.getParameter("userLat");
            String userLng = request.getParameter("userLng");

            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                ResultSet results = null;
                String query = "SELECT shops.name, lat, lng, "
                        + "(111.111 * DEGREES(ACOS(COS(RADIANS(lat)) "
                        + "* COS(RADIANS(" + userLat + ")) "
                        + "* COS(RADIANS(lng - " + userLng + ")) "
                        + "+ SIN(RADIANS(lat)) "
                        + "* SIN(RADIANS(" + userLat + "))))) AS dist_in_km "
                        + "FROM shops, shops_coordinates "
                        + "WHERE shops_coordinates.id_shop = shops.id "
                        + "HAVING dist_in_km <= 20.0;";
                
                //query += ";";
                results = MyDatabaseManager.EseguiQuery(query, connection);

                if (results.isAfterLast()) /** se non c'è un negozio che rispetta il criterio richiesto */
                {
                    /** ALLORA memorizzo l'errore, termino l'esecuzione della servlet e rimando alla pagina negoziVicini */
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noShopFound);
                    response.sendRedirect(request.getContextPath() + "/negoziVicini.jsp");
                    connection.close();
                    return;
                }

                /** ALTRIMENTI creo un oggetto json in cui memorizzo i prodotti trovati */
                jsonObj = MyDatabaseManager.GetJsonOfShopsInSet(results, connection);

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
