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
 * @author Davide 
 */
public class ServletFindProduct extends HttpServlet {

    /**
     * SerlvetFindProduct
     * 
     * Questa servlet ha il compito di estrarre dal db tutti i prodotti (e le relative informazioni)
     * che soddisfano il parametro di ricerca specificati dall'utente.
     * 
     * @param request contiene i campi con cui l'utente può cercare i prodotti. Compresi gli eventuali tipi di filtri applicati e i dati per applicarli 
     * @return
     * 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userReceived = request.getParameter("username"); // NULL, ma non viene mai usato
            String productReceived = request.getParameter("txtCerca");
            String categoriaReceived = request.getParameter("categoriaRicerca");
            String recensioneReceived = request.getParameter("recensioneRicerca");
            String distanzaReceived = request.getParameter("distanzaRicerca");
            String prezzoMinRicerca = request.getParameter("prezzoMinRicerca");
            String prezzoMaxRicerca = request.getParameter("prezzoMaxRicerca");
            String userLat = request.getParameter("latRicerca");
            String userLng = request.getParameter("lngRicerca");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                ResultSet results = null;
                String query = "";
                
                if(recensioneReceived != null){
                    /** in caso l'utente abbia specificato il filtro della distanza, i prodotti cercati saranno in un determinato raggio dalla sua posizione */
                    if(distanzaReceived != null){
                        query += "SELECT products.*, pictures.path, "
                                + "(111.111 * DEGREES(ACOS(COS(RADIANS(lat)) "
                                + "* COS(RADIANS(" + userLat + ")) "
                                + "* COS(RADIANS(lng - " + userLng + ")) "
                                + "+ SIN(RADIANS(lat)) "
                                + "* SIN(RADIANS(" + userLat + "))))) AS dist_in_km "
                                + "FROM products, shops, shops_coordinates, users, , pictures, "
                                + "(SELECT products.id, AVG(global_value) AS avg "
                                + "FROM products, reviews WHERE products.ID = reviews.ID_PRODUCT GROUP BY products.id) as sub "
                                + "WHERE products.id = sub.id AND products.id_shop = shops.id AND shops_coordinates.id_shop = shops.id "
                                + "AND avg >= " + recensioneReceived + " "
                                + "AND products.ritiro = 1 "
                                + "AND products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER AND pictures.id_product = products.id "
                                + "HAVING dist_in_km <= " + distanzaReceived + " AND ";
                    } else {
                        /** ????????? ALTRIMENTI, verranno restituiti tutti i prodottiche soddifano il criterio dell ....... */
                        query += "SELECT products.*,pictures.path, "
                                + "FROM products, shops, users, pictures,"
                                + "(SELECT products.id, AVG(global_value) AS avg "
                                + "FROM products, reviews WHERE products.ID = reviews.ID_PRODUCT GROUP BY products.id) as sub "
                                + "WHERE products.id_shop = shops.id "
                                + "AND products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER AND pictures.id_product = products.id "
                                + "AND products.ID = sub.id AND avg >= " + recensioneReceived + " AND ";
                    }
                } else if(distanzaReceived != null){
                    query += "SELECT products.*, pictures.path, "
                            + "(111.111 * DEGREES(ACOS(COS(RADIANS(lat)) "
                            + "* COS(RADIANS(" + userLat + ")) "
                            + "* COS(RADIANS(lng - " + userLng + ")) "
                            + "+ SIN(RADIANS(lat)) "
                            + "* SIN(RADIANS(" + userLat + "))))) AS dist_in_km "
                            + "FROM products, shops, shops_coordinates, users, pictures "
                            + "WHERE products.id_shop = shops.id AND shops_coordinates.id_shop = shops.id "
                            + "AND products.ritiro = 1 "
                            + "AND products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER AND pictures.id_product = products.id "
                            + "HAVING dist_in_km <= " + distanzaReceived + " AND ";
                } else {
                    query += "SELECT products.*, pictures.path "
                            + "FROM products, shops, users, pictures "
                            + "WHERE products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER AND pictures.id_product = products.id "
                            + "AND products.id_shop = shops.id AND ";
                }
                
                // esegue solo su condizione
                if(prezzoMinRicerca != null){
                    query += "products.price >= " + prezzoMinRicerca + " AND ";
                }
                
                if(prezzoMaxRicerca != null){
                    query += "products.price <= " + prezzoMaxRicerca + " AND ";
                }
                
                // esegue sempre
                switch (categoriaReceived) {
                    case "product":
                        query += "products.name = '" + MyDatabaseManager.EscapeCharacters(productReceived) + "' ORDER BY products.price ASC;";
                        break;
                    case "seller": 
                        query += "shops.name = '" + MyDatabaseManager.EscapeCharacters(productReceived) + "' ORDER BY products.price ASC;";
                        break;
                    case "category":                    
                        query += "products.category = '" + MyDatabaseManager.EscapeCharacters(productReceived) + "' ORDER BY products.price ASC;";
                        break;
                    default:
                        break;
                }
                
                results = MyDatabaseManager.EseguiQuery(query, connection);
                
                if (results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noProductFound);
                    response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                    connection.close();
                    return;
                }

                //aggiungo i prodotti al json
                jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);

                HttpSession session = request.getSession();

                /*
                // crasha se non sei loggato, perchè non riesce a trovare l'attributo userID...
                String userID = session.getAttribute("userID").toString();
                session.setAttribute("jsonNotifiche",Notifications.GetJson(userID, connection));
                 */
                // TMP
                //String userID = session.getAttribute("userID").toString();
                if (session.getAttribute("userID") != null) {
                    session.setAttribute("jsonNotifiche", Notifications.GetJson(session.getAttribute("userID").toString(), connection));
                } else {
                    session.setAttribute("jsonNotifiche", "{\"notifications\": []}");
                }

                session.setAttribute("jsonProdotti", jsonObj);
                session.setAttribute("searchedProduct", productReceived);

                connection.close();

                response.sendRedirect(request.getContextPath() + "/searchPage.jsp"); 
            } else {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        } catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletFindProduct", ex.toString());
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
