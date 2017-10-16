/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import com.amazoff.classes.Notifications;
import java.sql.Connection;
import java.util.UUID; // per il generatore di stringhe random

/**
 *
 * @author DVD_01
 */
public class ServletRegister extends HttpServlet {

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
            
            String nameReceived = request.getParameter("name");
            String surnameReceived = request.getParameter("surname");
            String emailReceived = request.getParameter("email");
            String userReceived = request.getParameter("username");
            String pwdReceived = request.getParameter("hashedPassword");
           
            /*String db_host = "jdbc:mysql://localhost:3306/fantaf1db";
            String db_user = "root";
            String db_pwd = "root";*/
            
            //Connection connection = null;
            if(!MyDatabaseManager.alreadyExists) //se non esiste lo creo
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
                mydb.CreateConnection();    
            }
            
            //Chiedi roba al db
            String dbName = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM users WHERE username = '" + MyDatabaseManager.EscapeCharacters(userReceived) + "';", connection);
                
                while (results.next()) {
                    dbName = results.getString(4); // 4 = colonna della tab users contenente gli username
                }
                
                connection.close();
                
                if(dbName.equals(userReceived)) //Allora l'utente esiste già
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.usernameTaken);
                    response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
                }
                else
                {
                    connection = MyDatabaseManager.CreateConnection();
<<<<<<< HEAD
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    Date date = new Date();
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO users(first_name, last_name, username, pass, registration_date, email, usertype, passrecupero) " + 
=======
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO users(first_name, last_name, username, pass, registration_date, email, usertype) " + 
>>>>>>> 790740c3ecd67c37c9087e08f74619641b550883
                                                        "VALUES (" + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(nameReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(surnameReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(userReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(pwdReceived) + "', " + 
<<<<<<< HEAD
                                                        "'" + dateFormat.format(date) + "', " +
                                                        "'" + MyDatabaseManager.EscapeCharacters(emailReceived) + "', 0," +
                                                        "'" + generateString()+ "');", connection);
=======
                                                        "'" + MyDatabaseManager.GetCurrentDate() + "', " +
                                                        "'" + MyDatabaseManager.EscapeCharacters(emailReceived) + "', 0);", connection);
>>>>>>> 790740c3ecd67c37c9087e08f74619641b550883
                    
                    String userID = String.valueOf(MyDatabaseManager.GetID_User(userReceived));
                    
                    Notifications.SendNotification(userID, Notifications.NotificationType.NEW_USER, "/Amazoff/userPage.jsp", connection);
                    
                    
                    connection.close();
                    //Prosegui con la pagina corretta
                    HttpSession session = request.getSession();
                    session.setAttribute("userID", userID);
                    session.setAttribute("user", userReceived);
                    session.setAttribute("categoria_user", "0");
                    session.setAttribute("fname", nameReceived);
                    session.setAttribute("lname", surnameReceived);                    
                    session.setAttribute("errorMessage", Errors.resetError);
                    response.sendRedirect(request.getContextPath() + "/afterRegistration.jsp");
                    //request.getRequestDispatcher("/GestioneSquadra").forward(request, response);
                }
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/");
            }
            
        }catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletRegister", ex.toString());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/");
        }           
    }
    
    private static String generateString() {
        int x = 0;
        for (int i = 0; i < 99999; i++) {
            if(UUID.randomUUID().toString().contains("\'"))
                x++;
        }
        for (int i = 0; i < 99999; i++) {
            if(UUID.randomUUID().toString().contains("\'"))
                x++;
        }
        for (int i = 0; i < 99999; i++) {
            if(UUID.randomUUID().toString().contains("\'"))
                x++;
        }
        for (int i = 0; i < 99999; i++) {
            if(UUID.randomUUID().toString().contains("\'"))
                x++;
        }
        int c = x;
        String uuid = UUID.randomUUID().toString();
        return uuid;
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
