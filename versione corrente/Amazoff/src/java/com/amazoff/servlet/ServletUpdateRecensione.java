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
 * Aggiunge, modifica o elimina una recensione per un'oggetto acquistato
 * dall'utente loggato.
 *
 * @author Caterina Battisti
 */
public class ServletUpdateRecensione extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String id_recensione = request.getParameter("id_review");
            String id_prodotto = request.getParameter("id_product");
            String titolo = request.getParameter("review_name");
            String recensione = request.getParameter("review_text");
            String quality = request.getParameter("quality_rating");
            String service = request.getParameter("service_rating");
            String value = request.getParameter("value_rating");
            String global = request.getParameter("global_rating");
            String to_update = request.getParameter("to_update");
            String to_delete = request.getParameter("to_delete");
            HttpSession session = request.getSession();

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

            if (MyDatabaseManager.cpds != null) {
                Connection connection = MyDatabaseManager.CreateConnection();

                if (session.getAttribute("userID") != null) {
                    if (to_delete.equals("true")) {
                        int results = MyDatabaseManager.EseguiUpdate("DELETE FROM reviews WHERE id = " + id_recensione + ";", connection);

                        if (results == 0) {
                            session.setAttribute("errorMessage", Errors.deleteUnsuccessful);
                            response.sendRedirect(request.getContextPath() + "/");
                        }
                    } else {
                        /**
                         * Interrogo il Db per farmi restituire i dettagli del
                         * prodotto specificato
                         */
                        if (to_update.equals("true")) {
                            int results = MyDatabaseManager.EseguiUpdate("UPDATE reviews SET description = '" + recensione + "'"
                                    + ", name = '" + titolo + "'"
                                    + ", global_value = " + global
                                    + ", quality = " + quality
                                    + ", service = " + service
                                    + ", value_for_money = " + value
                                    + " WHERE id = " + id_recensione + ";", connection);

                            /**
                             * se l'update non è andata a buon fine
                             */
                            if (results == 0) {
                                session.setAttribute("errorMessage", Errors.updateUnsuccessful);
                                response.sendRedirect(request.getContextPath() + "/");
                            }
                        } else {
                            int results = MyDatabaseManager.EseguiUpdate("INSERT INTO reviews (global_value, quality, service, value_for_money, name, description, id_product, id_creator) VALUES ("
                                    + global + ", "
                                    + quality + ", "
                                    + service + ", "
                                    + value + ", '"
                                    + titolo + "', '"
                                    + recensione + "', "
                                    + id_prodotto + ", "
                                    + session.getAttribute("userID") + ");", connection);

                            /**
                             * se l'insert non è andata a buon fine
                             */
                            if (results == 0) {
                                session.setAttribute("errorMessage", Errors.insertUnsuccessful);
                                response.sendRedirect(request.getContextPath() + "/");
                            }
                        }
                    }
                    connection.close();

                    response.sendRedirect(request.getContextPath() + "/ServletMyOrders");
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
