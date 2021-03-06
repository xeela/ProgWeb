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
 * Recupera i dati delle controversie non ancora risolte se l'utente loggato è admin.
 * 
 * @author Caterina Battisti
 */
public class ServletRecuperaAnomalie extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            HttpSession session = request.getSession();
            String userID = session.getAttribute("userID").toString();
            String is_admin = "";
            String jsonObj = "";
            ResultSet results;
            
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
            
            if(MyDatabaseManager.cpds != null){
                Connection connection = MyDatabaseManager.CreateConnection();
                
                if (userID != null) {
                    // controlla che l'utente sia admin
                    results = MyDatabaseManager.EseguiQuery("SELECT usertype FROM users WHERE id = " + userID + ";", connection);

                    while(results.next()){
                        is_admin = results.getString(1);
                    }

                    if(is_admin.equals("2")){
                        boolean isFirstTime = true;

                        results = MyDatabaseManager.EseguiQuery("SELECT id FROM anomalies WHERE solved = 0;", connection);
                        
                        jsonObj += "{";
                        jsonObj += "'data':[";
                        
                        while(results.next()){
                            if(!isFirstTime)            //metto la virgola prima dell'oggetto solo se non è il primo
                                jsonObj += ", ";
                            isFirstTime = false;
                    
                            jsonObj += "{'link':'/Amazoff/ServletSegnalazione?id=" + results.getString(1) + "',";
                            jsonObj += "'id':'" + results.getString(1) + "'}";
                        }

                        jsonObj += "]}";
                        
                        connection.close();
                        session.setAttribute("jsonAnomalies", jsonObj);
                        response.sendRedirect(request.getContextPath() + "/anomaliesPage.jsp");
                    }
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
