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
public class ServletRegister extends HttpServlet {

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
            String pwdReceived = request.getParameter("hashedPassword");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
                mydb.CreateConnection();    
            }
            
            String dbName = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** Cerco nel db se esiste già un profilo con l'username specificato */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT * FROM users WHERE username = '" + MyDatabaseManager.EscapeCharacters(userReceived) + "';", connection);
                
                while (results.next()) {
                    dbName = results.getString(4); // 4 = colonna della tab users contenente gli username
                }
                
                connection.close();
                
                /** Se si, l'username è già presente */
                if(dbName.equals(userReceived))
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.usernameTaken);
                    response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
                }
                else
                {
                    /** ALTRIMENTI: memorizzo i dati del nuovo utente nel db */
                    connection = MyDatabaseManager.CreateConnection();
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("INSERT INTO users(first_name, last_name, username, pass, registration_date, email, usertype, passrecupero) " + 
                                                        "VALUES (" + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(nameReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(surnameReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(userReceived) + "', " + 
                                                        "'" + MyDatabaseManager.EscapeCharacters(pwdReceived) + "', " + 
                                                        "'" + MyDatabaseManager.GetCurrentDate() + "', " +
                                                        "'" + MyDatabaseManager.EscapeCharacters(emailReceived) + "', 0," + 
                                                        "'" + generateString() +"' );", connection);
                    
                    String userID = String.valueOf(MyDatabaseManager.GetID_User(userReceived));
                    
                    Notifications.SendNotification(userID, Notifications.NotificationType.NEW_USER, "/Amazoff/userPage.jsp", connection);
                    
                    
                    connection.close();

                    HttpSession session = request.getSession();
                    session.setAttribute("userID", userID);
                    session.setAttribute("user", userReceived);
                    session.setAttribute("categoria_user", "0");
                    session.setAttribute("fname", nameReceived);
                    session.setAttribute("lname", surnameReceived);                    
                    session.setAttribute("errorMessage", Errors.resetError);
                    response.sendRedirect(request.getContextPath() + "/afterRegistration.jsp");
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
    
    /** Funzione che genera una stringa in modo casuale, da usare come password di recupero */
    private static String generateString() {
        
        String uuid = UUID.randomUUID().toString();
        return uuid;
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
