/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
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
 * @author DVD_01
 */
public class ServletFindProduct extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userReceived = request.getParameter("username"); // NULL, ma non viene mai usato
            String productReceived = request.getParameter("txtCerca");
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            String jsonObj = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                // Interrogo il Db per farmi dare i prodotti cercati con la searchbar
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT name, description, price, id FROM products WHERE name = '" + MyDatabaseManager.EscapeCharacters(productReceived) + "';", connection);
                
                if(results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
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
                /*// crasha se non sei loggato, perchè non riesce a trovare l'attributo userID...
                String userID = session.getAttribute("userID").toString();
                session.setAttribute("jsonNotifiche",Notifications.GetJson(userID, connection));
                */
                // TMP
                try 
                {
                    String userID = session.getAttribute("userID").toString();
                    session.setAttribute("jsonNotifiche",Notifications.GetJson(userID, connection));
                }catch(Exception e) {}
                
                session.setAttribute("jsonProdotti", jsonObj);
                session.setAttribute("searchedProduct", productReceived);
                
                connection.close();
                
                response.sendRedirect(request.getContextPath() + "/searchPage.jsp"); //TODO: Gestire meglio l'errore
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        }catch (SQLException ex) {
            HttpSession session = request.getSession();
            MyDatabaseManager.LogError(session.getAttribute("user").toString(), "ServletFindProduct", ex.toString());
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
        }
    }
    
     // IDEA DA SVILUPPARE in base all'ID prodotto, ricavo il path delle img a lui associate
    /*private String productPictures(String ID_product, Connection connection, HttpServletRequest request, HttpServletResponse response) 
    {
        try (PrintWriter out = response.getWriter()) {
            ResultSet results = MyDatabaseManager.EseguiQuery("SELECT name, description, price, id FROM products WHERE name = '" + ID_product + "';", connection);

            if(results.isAfterLast()) //se non c'è un prodotto che rispetta il criterio richiesto
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.noProductFound);
                response.sendRedirect(request.getContextPath() + "/searchPage.jsp");
                connection.close();
            }


        }catch (IOException ex) {
            try {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbQuery);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            } catch (IOException ex1) {
                Logger.getLogger(ServletFindProduct.class.getName()).log(Level.SEVERE, null, ex1);
            }
        }
        return "";

    }*/

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
