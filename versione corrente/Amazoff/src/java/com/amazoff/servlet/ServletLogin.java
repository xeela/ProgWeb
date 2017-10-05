/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import java.sql.Connection;

/**
 *
 * @author Davide
 */
public class ServletLogin extends HttpServlet {

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
            String userReceived = request.getParameter("username");
            String pwdReceived = request.getParameter("hashedPassword");

           //Connessione al Database
            //String db_host = "jdbc:mysql://localhost:3306/fantaf1db";
            //String db_user = "root";
            //String db_pwd = "root";
            
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            //Chiedi roba al db
            String dbPwd = "";
            String categoriaUser = "";  // = 0, utente registrato
                                       // = 1, utente venditore
                                       // = 2, utente admin
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT pass, userType FROM users WHERE username = '" + userReceived + "';", connection);
                
                if(results.isAfterLast()) //se non c'è un utente con quel nome
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.usernameDoesntExist);
                    response.sendRedirect(request.getContextPath() + "/");
                    connection.close();
                    return;
                }
                
                while (results.next()) {
                    dbPwd = results.getString(1);
                    categoriaUser = results.getString(2);
                }
                
                connection.close();
                
                if(dbPwd.equals(pwdReceived)) //Allora la password è giusta
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("user", userReceived);
                    session.setAttribute("categoria_user", categoriaUser);
                    session.setAttribute("errorMessage", Errors.resetError);
                    response.sendRedirect(request.getContextPath() + "/");
                    
                }
                else //la password è sbagliata
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.wrongPassword);
                    response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
                } 
                    
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
            }
        }catch (SQLException ex) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/"); //TODO: Gestire meglio l'errore
        }
    }

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
