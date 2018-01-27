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
 * Questa servlet ha il compito di estrarre dal db tutti i prodotti (e le
 * relative informazioni) che soddisfano il parametro di ricerca specificati
 * dall'utente.
 *
 * request contiene i campi con cui l'utente può cercare i prodotti. Compresi
 * gli eventuali tipi di filtri applicati e i dati per applicarli
 *
 * @author Davide Farina - Caterina Battisti
 */
public class ServletFindProduct extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /**
             * leggo i dati ricevuti dal client
             */
            String userReceived = request.getParameter("username"); // NULL, ma non viene mai usato
            String productReceived = request.getParameter("txtCerca");
            String categoriaReceived = request.getParameter("categoriaRicerca");
            String recensioneReceived = request.getParameter("recensioneRicerca");
            String distanzaReceived = request.getParameter("distanzaRicerca");
            String prezzoMinRicerca = request.getParameter("prezzoMinRicerca");
            String prezzoMaxRicerca = request.getParameter("prezzoMaxRicerca");
            String userLat = request.getParameter("latRicerca");
            String userLng = request.getParameter("lngRicerca");
            String sort_by = request.getParameter("sort_by");

            /**
             * se l'oggetto MyDatabaseManager non esiste, vuol dire che la
             * connessione al db non è presente
             */
            if (!MyDatabaseManager.alreadyExists) /**
             * se non esiste lo creo
             */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            String jsonObj = "";
            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                ResultSet results, resultsImages;
                String query = "";

                if (recensioneReceived != null) {
                    /**
                     * in caso l'utente abbia specificato il filtro della
                     * distanza, i prodotti cercati saranno in un determinato
                     * raggio dalla sua posizione
                     */
                    if (distanzaReceived != null) {
                        query += "SELECT DISTINCT products.*, "
                                + "users.LAST_NAME, users.FIRST_NAME, "
                                + "shops.NAME, shops.WEB_SITE_URL, "
                                + "(SELECT COUNT(*) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as num_reviews, "
                                + "(SELECT ROUND(AVG(global_value), 1) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as avg_global_value, "
                                + "(111.111 * DEGREES(ACOS(COS(RADIANS(lat)) "
                                + "* COS(RADIANS(" + userLat + ")) "
                                + "* COS(RADIANS(lng - " + userLng + ")) "
                                + "+ SIN(RADIANS(lat)) "
                                + "* SIN(RADIANS(" + userLat + "))))) AS dist_in_km "
                                + "FROM products, shops, shops_coordinates, users, pictures, "
                                + "(SELECT products.id, AVG(global_value) AS avg "
                                + "FROM products, reviews WHERE products.ID = reviews.ID_PRODUCT GROUP BY products.id) as sub "
                                + "WHERE products.id = sub.id AND products.id_shop = shops.id AND shops_coordinates.id_shop = shops.id "
                                + "AND products.available > 0 "
                                + "AND avg >= " + recensioneReceived + " "
                                + "AND products.ritiro = 1 "
                                + "AND products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER "
                                + "HAVING dist_in_km <= " + distanzaReceived + " AND ";
                    } else {
                        /**
                         * ALTRIMENTI, verranno restituiti tutti i prodotti che
                         * soddifano il criterio di ricerca per recensione
                         */
                        query += "SELECT DISTINCT products.*, "
                                + "users.LAST_NAME, users.FIRST_NAME, "
                                + "shops.NAME, shops.WEB_SITE_URL, "
                                + "(SELECT COUNT(*) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as num_reviews, "
                                + "(SELECT ROUND(AVG(global_value), 1) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as avg_global_value "
                                + "FROM products, shops, users, pictures,"
                                + "(SELECT products.id, AVG(global_value) AS avg "
                                + "FROM products, reviews WHERE products.ID = reviews.ID_PRODUCT GROUP BY products.id) as sub "
                                + "WHERE products.id_shop = shops.id "
                                + "AND products.available > 0 "
                                + "AND products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER "
                                + "AND products.ID = sub.id AND avg >= " + recensioneReceived + " AND ";
                    }
                } else if (distanzaReceived != null) {
                    query += "SELECT DISTINCT products.*, "
                            + "users.LAST_NAME, users.FIRST_NAME, "
                            + "shops.NAME, shops.WEB_SITE_URL, "
                            + "(SELECT COUNT(*) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as num_reviews, "
                            + "(SELECT ROUND(AVG(global_value), 1) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as avg_global_value, "
                            + "(111.111 * DEGREES(ACOS(COS(RADIANS(lat)) "
                            + "* COS(RADIANS(" + userLat + ")) "
                            + "* COS(RADIANS(lng - " + userLng + ")) "
                            + "+ SIN(RADIANS(lat)) "
                            + "* SIN(RADIANS(" + userLat + "))))) AS dist_in_km "
                            + "FROM products, shops, shops_coordinates, users, pictures "
                            + "WHERE products.id_shop = shops.id AND shops_coordinates.id_shop = shops.id "
                            + "AND products.available > 0 "
                            + "AND products.ritiro = 1 "
                            + "AND products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER "
                            + "HAVING dist_in_km <= " + distanzaReceived + " AND ";
                } else {
                    query += "SELECT DISTINCT products.*, "
                            + "users.LAST_NAME, users.FIRST_NAME, "
                            + "shops.NAME, shops.WEB_SITE_URL,"
                            + "(SELECT COUNT(*) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as num_reviews, "
                            + "(SELECT ROUND(AVG(global_value), 1) FROM reviews WHERE reviews.ID_PRODUCT = products.id) as avg_global_value "
                            + "FROM products, shops, users, pictures "
                            + "WHERE products.ID_SHOP = shops.ID and users.id = shops.ID_OWNER "
                            + "AND products.available > 0 "
                            + "AND products.id_shop = shops.id AND ";
                }

                if (prezzoMinRicerca != null) {
                    query += "products.price >= " + prezzoMinRicerca + " AND ";
                }

                if (prezzoMaxRicerca != null) {
                    query += "products.price <= " + prezzoMaxRicerca + " AND ";
                }

                switch (categoriaReceived) {
                    case "product":
                        query += "products.name LIKE '%" + MyDatabaseManager.EscapeCharacters(productReceived) + "%' ";
                        break;
                    case "seller":
                        query += "shops.name LIKE '%" + MyDatabaseManager.EscapeCharacters(productReceived) + "%' ";
                        break;
                    case "category":
                        query += "products.category = '" + MyDatabaseManager.EscapeCharacters(productReceived) + "' ";
                        break;
                    default:
                        break;
                }
                
                if(sort_by != null){
                    switch (sort_by) {
                        case "price_asc":
                            query += "ORDER BY products.price ASC;";
                            break;
                        case "price_desc":
                            query += "ORDER BY products.price DESC;";
                            break;
                        case "review_asc":
                            query += "ORDER BY avg_global_value ASC;";
                            break;
                        case "review_desc":
                            query += "ORDER BY avg_global_value DESC;";
                            break;
                        default:
                            break;
                    }
                } else {
                    query += "ORDER BY products.name ASC;";
                }

                results = MyDatabaseManager.EseguiQuery(query, connection);

                if (results.isAfterLast()) /**
                 * se non c'è un prodotto che rispetta il criterio richiesto
                 */
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noProductFound);
                    response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                    connection.close();
                    return;
                }

                /**
                 * creo un oggetto json, in cui memorizzo i dati
                 */
                String gloabl_value_avg = "";
                boolean isFirstTime = true, isFirstTimeImg = true;
                String id_product = "";
                jsonObj += "{";
                jsonObj += "\"products\":[";
                while (results.next()) {
                    isFirstTimeImg = true;
                    if (!isFirstTime) {
                        jsonObj += ", ";
                    }
                    isFirstTime = false;

                    id_product = results.getString(1);
                    gloabl_value_avg = results.getString(15);
                    jsonObj += "{";
                    jsonObj += "\"id\": \"" + id_product + "\",";
                    jsonObj += "\"name\": \"" + results.getString(2) + "\",";
                    jsonObj += "\"description\": \"" + results.getString(3) + "\",";
                    jsonObj += "\"price\": \"" + results.getString(4) + "\",";
                    jsonObj += "\"id_shop\": \"" + results.getString(5) + "\",";
                    jsonObj += "\"category\": \"" + results.getString(6) + "\",";
                    jsonObj += "\"ritiro\": \"" + results.getString(7) + "\",";
                    /* dati del venditore */
                    jsonObj += "\"last_name\": \"" + results.getString(10) + "\",";
                    jsonObj += "\"first_name\": \"" + results.getString(11) + "\",";
                    jsonObj += "\"shop_name\": \"" + results.getString(12) + "\",";
                    jsonObj += "\"site_url\": \"" + results.getString(13) + "\",";
                    jsonObj += "\"num_reviews\": \"" + results.getString(14) + "\",";
                    if (gloabl_value_avg == null) {
                        gloabl_value_avg = "0";
                    }
                    jsonObj += "\"global_value_avg\": \"" + gloabl_value_avg + "\",";
                    jsonObj += "\"categoriaReceived\": \"" + categoriaReceived + "\",";
                    jsonObj += "\"recensioneReceived\": \"" + recensioneReceived + "\",";
                    jsonObj += "\"distanzaReceived\": \"" + distanzaReceived + "\",";
                    jsonObj += "\"prezzoMinRicerca\": \"" + prezzoMinRicerca + "\",";
                    jsonObj += "\"prezzoMaxRicerca\": \"" + prezzoMaxRicerca + "\",";
                    jsonObj += "\"userLat\": \"" + userLat + "\",";
                    jsonObj += "\"userLng\": \"" + userLng + "\",";
                    
                    /**
                     * richiedo le immagini per questo prodotto
                     */
                    jsonObj += "\"pictures\": [";
                    resultsImages = MyDatabaseManager.EseguiQuery("SELECT path FROM pictures WHERE ID_PRODUCT = " + id_product + ";", connection);

                    /*if (resultsImages.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
                    {
                        HttpSession session = request.getSession();
                        session.setAttribute("errorMessage", Errors.noProductFound);
                        response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                        connection.close();
                        return;
                    }*/
                    while (resultsImages.next()) {
                        if (!isFirstTimeImg) {
                            jsonObj += ", ";
                        }
                        isFirstTimeImg = false;
                        jsonObj += "{";
                        jsonObj += "\"path\": \"" + resultsImages.getString(1) + "\"";
                        jsonObj += "}";
                    }

                    jsonObj += "]"; // chiusura array images

                    jsonObj += "}"; //chiusura dati prodotto
                }
                jsonObj += "]}";

                HttpSession session = request.getSession();

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
