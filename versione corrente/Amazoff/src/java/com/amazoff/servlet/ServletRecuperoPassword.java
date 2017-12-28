package com.amazoff.servlet;

import com.amazoff.classes.Errors;
import com.amazoff.classes.MyDatabaseManager;
import com.amazoff.classes.Notifications;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * @author Francesco
 */
public class ServletRecuperoPassword extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            
            String emailReceived = request.getParameter("email");
            String pwdReceived = request.getParameter("hashedPassword");
            String tmpPwdReceived = request.getParameter("tmpPassword");
            
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
                mydb.CreateConnection();    
            }
            
            String dbEmail = "", dbPwdRecupero = "";
            String userID = "", username = "", categoriaUser = "", lname = "", fname = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                /** Cerco nel db se esiste un profilo con l'email specificata */
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT email, passrecupero, ID, first_name, last_name, username, usertype FROM users WHERE email = '" + MyDatabaseManager.EscapeCharacters(emailReceived) + "' AND passrecupero = '" + MyDatabaseManager.EscapeCharacters(tmpPwdReceived) + "';", connection);
                
                while (results.next()) {
                    dbEmail = results.getString(1); 
                    dbPwdRecupero = results.getString(2);
                    userID = results.getString(3);
                    fname = results.getString(4);
                    lname = results.getString(5);
                    username = results.getString(6);
                    categoriaUser = results.getString(7);
                }
                
                connection.close();
                
                /** Se si, l'emal è già presente e la pwd temporanea corrisponde, allora aggiorno la pwd dell'utente e cambio quella temporanea generandone una nuova */
                if(dbEmail.equals(emailReceived) && dbPwdRecupero.equals(tmpPwdReceived))
                {
                    
                    /** Memorizzo i nuovi dati del nuovo utente nel db */
                    connection = MyDatabaseManager.CreateConnection();
                    PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE users SET " + 
                                                        "pass = '"+ MyDatabaseManager.EscapeCharacters(pwdReceived) + "', " + 
                                                        "passrecupero = '" + generateString() +"'"+
                                                        " WHERE ID = "+ userID +";", connection);
                    
                    connection.close();

                    HttpSession session = request.getSession();
                    /** memorizzo nella sessione, il nome, cognome, username e tipo di utente, in modo da utilizzare questi dati nelle altre pagine */
                    session.setAttribute("user", username);
                    session.setAttribute("userID", userID);
                    session.setAttribute("categoria_user", categoriaUser);
                    session.setAttribute("fname", fname);
                    session.setAttribute("lname", lname);
                    session.setAttribute("errorMessage", Errors.resetError);
                    //TMP
                    //Notifications.SendNotification(userID, Notifications.NotificationType.NEW_USER, "/Amazoff/userPage.jsp", connection);
                    //END TMP
                    response.sendRedirect(request.getContextPath() + "/");
                }
                else
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.isNotYourEmail);
                    response.sendRedirect(request.getContextPath() + "/");
                
                }
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/");
            }
            
        }catch (SQLException ex) {
            //MyDatabaseManager.LogError(request.getParameter("username"), "ServletRegister", ex.toString());
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
