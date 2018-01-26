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
 * Recupera i dati della singola controversia o inserisce una nuova
 * controversia.
 *
 * @author Caterina Battisti
 */
public class ServletSegnalazione extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            String recupera = request.getParameter("id");
            String orderID = request.getParameter("orderId");
            String productID = request.getParameter("productId");
            String objectID = "";
            int insert = 0;
            boolean in_db = false;
            String is_admin = "";
            String notificaUser = "";
            String anomalyID = "";
            String jsonObj = "";
            ResultSet results;

            if (!MyDatabaseManager.alreadyExists) /**
             * se non esiste lo creo
             */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                if (userID != null) {
                    if (recupera != null) {
                        // controlla che l'utente sia admin
                        results = MyDatabaseManager.EseguiQuery("SELECT usertype FROM users WHERE id = " + userID + ";", connection);

                        while (results.next()) {
                            is_admin = results.getString(1);
                        }

                        if (is_admin.equals("2")) {
                            results = MyDatabaseManager.EseguiQuery("SELECT anomalies.object_id, products.name, orders.order_date, anomalies.date, u.id, u.username, s.id "
                                    + "FROM anomalies, orders_products, orders, users as u, users as s, products, shops "
                                    + "WHERE anomalies.object_id = orders_products.id AND orders_products.order_id = orders.id AND "
                                    + "orders.who_ordered = u.id AND orders_products.product_id = products.id AND "
                                    + "products.id_shop = shops.id AND shops.id_owner = s.id AND "
                                    + "anomalies.id = " + recupera + ";", connection);

                            while (results.next()) {
                                jsonObj += "{";
                                jsonObj += "'data':[{";
                                jsonObj += "'anomaly_id':'" + recupera + "',";
                                jsonObj += "'object_id':'" + results.getString(1) + "',";
                                jsonObj += "'product_name':'" + results.getString(2) + "',";
                                jsonObj += "'sold_date':'" + results.getString(3) + "',";
                                jsonObj += "'anomaly_date':'" + results.getString(4) + "',";
                                jsonObj += "'user_id':'" + results.getString(5) + "',";
                                jsonObj += "'user_name':'" + results.getString(6) + "',";
                                jsonObj += "'seller_id':'" + results.getString(7) + "'";
                                jsonObj += "}]}";
                            }

                            connection.close();
                            session.setAttribute("jsonAnomaly", jsonObj);
                            response.sendRedirect(request.getContextPath() + "/gestisciAnomalia.jsp");
                        } else {
                            connection.close();
                            response.sendRedirect(request.getContextPath() + "/");
                        }
                    } else {
                        // controlla se l'anomalia è già stata segnalata
                        results = MyDatabaseManager.EseguiQuery("SELECT orders_products.id, anomalies.id FROM orders_products, anomalies WHERE orders_products.id = anomalies.object_id AND order_id = " + orderID + " AND product_id = " + productID + ";", connection);

                        if (results.next()) {
                            objectID = results.getString(1);
                            in_db = true;
                        }

                        if (in_db) {
                            // se l'anomalia è già stata segnalata, notifica l'utente
                            Notifications.SendNotification(userID, objectID, Notifications.NotificationType.ANOMALY_ERROR, "/Amazoff/userPage.jsp?v=Notifiche", connection);
                        } else {
                            // se l'anomalia non è già stata segnalata, invia segnalazione
                            results = MyDatabaseManager.EseguiQuery("SELECT orders_products.id FROM orders_products WHERE order_id = " + orderID + " AND product_id = " + productID + ";", connection);

                            while (results.next()) {
                                objectID = results.getString(1);
                            }

                            insert = MyDatabaseManager.EseguiUpdate("INSERT INTO anomalies (object_id, solved, action) VALUES (" + objectID + ", 0, 0);", connection);

                            if (insert != 0) {
                                results = MyDatabaseManager.EseguiQuery("SELECT id FROM anomalies WHERE object_id = " + objectID + ";", connection);

                                if (results.next()) {
                                    anomalyID = results.getString(1);
                                }

                                // recupera l'id dell'admin
                                results = MyDatabaseManager.EseguiQuery("SELECT id FROM users WHERE usertype = 2;", connection);

                                if (results.next()) {
                                    notificaUser = results.getString(1);
                                }
                                
                                // notifica l'admin
                                Notifications.SendNotification(notificaUser, objectID, Notifications.NotificationType.ANOMALY, "/Amazoff/ServletSegnalazione?id=" + anomalyID, connection);
                                
                                // recupera l'id del venditore
                                results = MyDatabaseManager.EseguiQuery("SELECT shops.id_owner FROM orders_products, products, shops WHERE orders_products.product_id = products.id AND products.id_shop = shops.id AND order_id = " + orderID + " AND product_id = " + productID + ";", connection);

                                if (results.next()) {
                                    notificaUser = results.getString(1);
                                }

                                // notifica il venditore
                                Notifications.SendNotification(notificaUser, objectID, Notifications.NotificationType.ANOMALY, "/Amazoff/userPage.jsp?v=Notifiche", connection);

                                // notifica l'utente
                                Notifications.SendNotification(userID, objectID, Notifications.NotificationType.ANOMALY, "/Amazoff/userPage.jsp?v=Notifiche", connection);
                            }
                        }

                        connection.close();
                        response.sendRedirect(request.getContextPath() + "/ServletMyOrders");
                    }
                }
            } else {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/");
            }
        } catch (SQLException ex) {
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
