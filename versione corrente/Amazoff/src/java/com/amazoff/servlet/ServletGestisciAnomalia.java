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
 * Aggiorna lo stato della controversia con l'azione stabilita
 * dall'amministratore.
 *
 * @author Caterina Battisti
 */
public class ServletGestisciAnomalia extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String anomalyID = request.getParameter("anomaly_id");
            String objectID = request.getParameter("object_id");
            String action = request.getParameter("radio_action");
            String user_anomaly = request.getParameter("user_anomaly");
            String seller_id = request.getParameter("seller_id");
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            int update;
            ResultSet results;
            String redirect = "/index.jsp";
            String is_solved = "";

            if (!MyDatabaseManager.alreadyExists) /**
             * se non esiste lo creo
             */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }

            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                if (userID != null) {
                    results = MyDatabaseManager.EseguiQuery("SELECT solved FROM anomalies WHERE id = " + anomalyID + ";", connection);

                    if (results.next()) {
                        is_solved = results.getString(1);
                    }

                    if (is_solved.equals("0")) {
                        update = MyDatabaseManager.EseguiUpdate("UPDATE anomalies SET action = " + action + ", solved = 1 WHERE id = " + anomalyID + ";", connection);

                        if (update != 0) {
                            redirect = "/ServletRecuperaAnomalie";
                        }

                        switch (action) {
                            case "1":
                                Notifications.SendNotification(user_anomaly, objectID, Notifications.NotificationType.RIMBORSO, "/Amazoff/index.jsp?", connection);
                                Notifications.SendNotification(seller_id, objectID, Notifications.NotificationType.RIMBORSO, "/Amazoff/index.jsp?", connection);
                                break;
                            case "2":
                                Notifications.SendNotification(user_anomaly, objectID, Notifications.NotificationType.NESSUN_ESITO, "/Amazoff/index.jsp?", connection);
                                Notifications.SendNotification(seller_id, objectID, Notifications.NotificationType.DIFFIDA, "/Amazoff/index.jsp?", connection);
                                break;
                            case "3":
                                Notifications.SendNotification(user_anomaly, objectID, Notifications.NotificationType.RIGETTATA, "/Amazoff/index.jsp?", connection);
                                Notifications.SendNotification(seller_id, objectID, Notifications.NotificationType.RIGETTATA, "/Amazoff/index.jsp?", connection);
                                break;
                            default:
                                break;
                        }
                    }
                }

                connection.close();
                response.sendRedirect(request.getContextPath() + redirect);
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
