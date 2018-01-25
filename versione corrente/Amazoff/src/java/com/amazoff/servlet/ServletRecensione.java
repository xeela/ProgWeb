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
 * Recupera i dati della recensione per l'oggetto acquistato 
 * inserita dall'utente loggato.
 *
 * @author Caterina Battisti
 */
public class ServletRecensione extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String id_prodotto = request.getParameter("id");          
            HttpSession session = request.getSession();
            String jsonObj = "";
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (session.getAttribute("userID") != null) {
                    /** Interrogo il Db per farmi restituire i dettagli del prodotto specificato */
                    ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM reviews, products WHERE reviews.id_product = products.id AND reviews.id_creator = "+ session.getAttribute("userID") +" AND products.id = "+ id_prodotto +";", connection);
                    
                    /** se non c'è il prodotto specificato */
                    if (!results.isBeforeFirst()) {
                        results = MyDatabaseManager.EseguiQuery("SELECT id, name FROM products WHERE id = "+ id_prodotto +";", connection);
                         
                        if (!results.isBeforeFirst()) {
                            jsonObj += "{}";
                        } else{
                            while (results.next()) {
                                jsonObj += "{";
                                jsonObj += "\"data\":[{";
                                jsonObj += "\"in_db\": \"false\",";
                                jsonObj += "\"id_product\": \"" + results.getString(1) + "\",";
                                jsonObj += "\"name_product\": \"" + results.getString(2) + "\"";
                                jsonObj += "}]}";
                            }
                        }
                    } else {
                        while (results.next()) {
                            jsonObj += "{";
                            jsonObj += "\"data\":[{";
                            jsonObj += "\"in_db\": \"true\",";
                            jsonObj += "\"id_review\": \"" + results.getString(1) + "\",";
                            jsonObj += "\"global\": \"" + results.getString(2) + "\",";
                            jsonObj += "\"quality\": \"" + results.getString(3) + "\",";
                            jsonObj += "\"service\": \"" + results.getString(4) + "\",";
                            jsonObj += "\"value\": \"" + results.getString(5) + "\",";
                            jsonObj += "\"title\": \"" + results.getString(6) + "\",";
                            jsonObj += "\"description\": \"" + results.getString(7) + "\",";
                            jsonObj += "\"date\": \"" + results.getString(8) + "\",";
                            jsonObj += "\"id_product\": \"" + results.getString(9) + "\",";
                            jsonObj += "\"id_creator\": \"" + results.getString(10) + "\",";
                            jsonObj += "\"name_product\": \"" + results.getString(12) + "\"";
                            jsonObj += "}]}";
                        }
                    }
                    connection.close();

                    session.setAttribute("jsonReview", jsonObj);
                    response.sendRedirect(request.getContextPath() + "/lasciaRecensione.jsp"); 
                }
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
