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
 *
 * 
 * Questa servlet ha il compito di fornire i 6 prodotti da visualizzare all'interno della home page.
 * Questi 6 elementi vengono scelti prendendo gli ultimi 6 elementi (i più recenti) inseriti nel database
 * 
 * ritorna jsonProdottiIndex che contiene i prodotti e le relative informazioni
 *  @author Francesco Bruschetti
 */
public class ServletIndexProducts extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
                       

            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            String jsonObj = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** Interrogo il Db per farmi dare i prodotti da inserire nella homepage */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT id,name, description, price FROM products ORDER BY id DESC LIMIT 6;", connection);
                
                if(results.isAfterLast()) /** se non sono presenti prodotti */
                {
                    /** allora reindirizzo l'utente alla pagina specificata */
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.noProductFound);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }
                               
                
                /** creo il jsonProdottiIndex in cui memorizzo i dati dei prodotti e i loro dettagli */
                jsonObj = MyDatabaseManager.GetJsonOfProductsInSet(results, connection);
                
                connection.close();
                
                HttpSession session = request.getSession();  
                session.setAttribute("jsonProdottiIndex", jsonObj);
                response.sendRedirect(request.getContextPath() + "/index.jsp"); 
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); 
            }
        }catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletIndexProducts", ex.toString());
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
