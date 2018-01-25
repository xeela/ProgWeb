package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Aggiorna lo stato della controversia con l'azione stabilita dall'amministratore.
 *
 * @author Caterina
 */
public class ServletGestisciAnomalia extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String anomalyID = request.getParameter("anomaly_id");
            String action = request.getParameter("radio_action");
            String user_anomaly = request.getParameter("user_anomaly");
            String seller = request.getParameter("seller");
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            int update;
            String redirect = "";
            
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
            
            if(MyDatabaseManager.cpds != null){
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (userID != null) {
                    update = MyDatabaseManager.EseguiUpdate("UPDATE anomalies SET action = " + action + ", solved = 1 WHERE id = " + anomalyID + ";", connection);
                    
                    // TODO: effettuare le operazioni per ogni azione
                    // 1 = rimborso --> notifica a utente e venditore
                    // 2 = segnalazione negativa venditore --> recensione negativa/notifica con sanzione/ecc
                    // 3 = rigetta --> notifica a utente e venditore
                    
                    if(update != 0){
                        redirect = "/anomaliesPage.jsp";
                    }
                }
                
                connection.close();
                response.sendRedirect(request.getContextPath() + redirect);
            } else {
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
    }// </editor-fold>

}
