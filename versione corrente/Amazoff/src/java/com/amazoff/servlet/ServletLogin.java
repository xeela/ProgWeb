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
 * Questa servlet riceve i dati specificati dall'utente, tramite la form di login, e controllare che siano validi.
 * 
 * request contiene l'username/email e l'hash della password da utilizzare per verificare che l'utente abbia un profilo.
 * 
 * @author Davide Farina
 */
public class ServletLogin extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            String userReceived = request.getParameter("username");
            String pwdReceived = request.getParameter("hashedPassword");
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            String username = "";
            String userID = "";
            String dbPwd = "";
            String email = "";
            String categoriaUser = "";  /** = 0, utente registrato
                                        * = 1, utente venditore
                                        * = 2, utente admin */
            String fname = "", lname = "";
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                ResultSet results;
                /** Controllo quale metodo sta usando l'utente per eseguire il login */
                /** SE ha usato la mail */
                if(userReceived.contains("@"))
                    results = MyDatabaseManager.EseguiQuery("SELECT pass, userType, first_name, last_name, ID, username, email FROM users WHERE email = '" + MyDatabaseManager.EscapeCharacters(userReceived) + "';", connection);
                /** OPPURE se ha usato il suo username */
                else
                    results = MyDatabaseManager.EseguiQuery("SELECT pass, userType, first_name, last_name, ID, username, email FROM users WHERE username = '" + MyDatabaseManager.EscapeCharacters(userReceived) + "';", connection);
                
                if(results.isAfterLast()) /** se non c'è un utente con quel nome/mail */
                {
                    /** ALLORA: memorizzo l'errore in modo da mostrarlo all'utente nella pagina di login */
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.usernameDoesntExist);
                    response.sendRedirect(request.getContextPath() + "/loginPage.jsp");
                    connection.close();
                    return;
                }
                
                while (results.next()) {
                    dbPwd = results.getString(1);
                    categoriaUser = results.getString(2);
                    fname = results.getString(3); 
                    lname = results.getString(4); 
                    userID = results.getString(5);
                    username = results.getString(6);
                    email = results.getString(7);
                }
                
                /** Controllo se la password inserita dall'utente è corretta */
                if(dbPwd.equals(pwdReceived))
                {
                    HttpSession session = request.getSession();
                    /** memorizzo nella sessione, il nome, cognome, username e tipo di utente, in modo da utilizzare questi dati nelle altre pagine */
                    session.setAttribute("user", username);
                    session.setAttribute("userID", userID);
                    session.setAttribute("categoria_user", categoriaUser);
                    session.setAttribute("fname", fname);
                    session.setAttribute("lname", lname);
                    session.setAttribute("email", email);
                    session.setAttribute("errorMessage", Errors.resetError);
                    //TMP
                    //Notifications.SendNotification(userID, "-1", Notifications.NotificationType.NEW_USER, "/Amazoff/userPage.jsp", connection);
                    //END TMP
                    response.sendRedirect(request.getContextPath() + "/");
                    
                }
                else /** la password è sbagliata */
                {
                    HttpSession session = request.getSession();
                    session.setAttribute("errorMessage", Errors.wrongPassword);
                    response.sendRedirect(request.getContextPath() + "/loginPage.jsp"); 
                } 
                
                connection.close();
                    
            }
            else
            {
                HttpSession session = request.getSession();
                session.setAttribute("errorMessage", Errors.dbConnection);
                response.sendRedirect(request.getContextPath() + "/loginPage.jsp"); 
            }
        }catch (SQLException ex) {
            MyDatabaseManager.LogError(request.getParameter("username"), "ServletLogin", ex.toString());
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", Errors.dbQuery);
            response.sendRedirect(request.getContextPath() + "/loginPage.jsp"); 
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
