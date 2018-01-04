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
import java.util.UUID;

/**
 *
 * @author Davide Farina
 */
public class ServletUpdateCredentials extends HttpServlet {

    /**
     * ServletRegister
     * 
     * Questa servlet permette ad un utente di registrarsi al sito 
     *
     * @param request contiene i dati relativi al profilo del nuovo utente 
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            
            String nameReceived = request.getParameter("name");
            String surnameReceived = request.getParameter("surname");
            String emailReceived = request.getParameter("email");
            String userReceived = request.getParameter("username");
            String oldpwdReceived = request.getParameter("oldPassword");
            String newpwdReceived = request.getParameter("hashedPassword");
                               
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
                mydb.CreateConnection();    
            }
            
            HttpSession session = request.getSession();
            session.getAttribute("userID");
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                connection = MyDatabaseManager.CreateConnection();
                PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE users SET first_name = '" + MyDatabaseManager.EscapeCharacters(nameReceived)+ "', " + 
                                                    " last_name = '"+MyDatabaseManager.EscapeCharacters(surnameReceived)+ "', " + 
                                                    "username= '"+ MyDatabaseManager.EscapeCharacters(userReceived) + "', " + 
                                                    "pass = '"+ MyDatabaseManager.EscapeCharacters(newpwdReceived) + "', " + 
                                                    "email= '"+ MyDatabaseManager.EscapeCharacters(emailReceived) + 
                                                    "' WHERE ID= "+session.getAttribute("userID") +";", connection);

                String userID = String.valueOf(MyDatabaseManager.GetID_User(userReceived));


                connection.close();

                session.setAttribute("userID", userID);
                session.setAttribute("user", userReceived);
                session.setAttribute("categoria_user", "0");
                session.setAttribute("fname", nameReceived);
                session.setAttribute("lname", surnameReceived);                    
                session.setAttribute("errorMessage", Errors.resetError);
                response.sendRedirect(request.getContextPath() + "/index.jsp");

            }
            else
            {
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/");
            }
            
        }catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletUpdate", ex.toString());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/");
        }           
    }
    
    /** Funzione che genera una stringa in modo casuale, da usare come password di recupero */
    private static String generateString() {
        
        String uuid = UUID.randomUUID().toString();
        return uuid;
    }
    
    /******** TMP: 
    private static void generateNString() {
        
        String[] tmp = new String[50];
        for (int i = 0; i < 50; i++) {
            String uuid = UUID.randomUUID().toString();
            tmp[i] = uuid;
        }
        tmp = tmp;
    }*/

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
