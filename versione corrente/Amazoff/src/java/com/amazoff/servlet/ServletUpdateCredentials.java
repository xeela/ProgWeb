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
 * @author Gianluca Pasqua
 * 
 * Questa servlet permette ad un utente di modificare le sue informazioni personali
 *
 * request contiene i dati relativi al profilo del nuovo utente 
 */
public class ServletUpdateCredentials extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            
            String nameReceived = request.getParameter("name");
            String surnameReceived = request.getParameter("surname");
            String emailReceived = request.getParameter("email");
            String userReceived = request.getParameter("username");
            String oldpwdReceived = request.getParameter("oldhashedPassword");
            String newpwdReceived = request.getParameter("hashedPassword");
                               
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
                mydb.CreateConnection();    
            }
            
            HttpSession session = request.getSession();
            String userID = (String) session.getAttribute("userID");
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                
                connection = MyDatabaseManager.CreateConnection();
                String userEmail = "";
                ResultSet userEmailset = MyDatabaseManager.EseguiQuery("SELECT EMAIL FROM users WHERE ID = '"+ userID + "'", connection);
                while (userEmailset.next()){
                    userEmail = userEmailset.getString(1);
                }
                Boolean invalidemail = false;
                if(userEmail != emailReceived){
                    ResultSet emailexists = MyDatabaseManager.EseguiQuery("SELECT ID FROM users WHERE EMAIL = '"+ emailReceived + "'", connection);
                    while (emailexists.next()) {
                        if(emailexists.getString(1) == null ? userID != null : !emailexists.getString(1).equals(userID))
                        {
                            invalidemail = true;
                            break;
                        }
                    }
                }
                String correspondinguser = "";
                Boolean invaliduser = false;
                ResultSet userexists = MyDatabaseManager.EseguiQuery("SELECT ID FROM users WHERE USERNAME = '"+ userReceived + "'", connection);
                while (userexists.next()) {
                    if(userexists.getString(1) == null ? userID != null : !userexists.getString(1).equals(userID))
                    {
                        invaliduser = true;
                        break;
                    }
                }
                ResultSet vecchiapassword = MyDatabaseManager.EseguiQuery("SELECT PASS FROM users WHERE ID = "+ userID, connection);
                
                String vecchiapwd = "";
                while (vecchiapassword.next()) {
                    vecchiapwd = vecchiapassword.getString(1);
                }
                if( !invalidemail )
                {
                    if(vecchiapwd.equals(oldpwdReceived)){

                            if(!invaliduser)
                            {
                                PreparedStatement ps = MyDatabaseManager.EseguiStatement("UPDATE users SET first_name = '" + MyDatabaseManager.EscapeCharacters(nameReceived)+ "', " + 
                                                                    " last_name = '"+MyDatabaseManager.EscapeCharacters(surnameReceived)+ "', " + 
                                                                    "username= '"+ MyDatabaseManager.EscapeCharacters(userReceived) + "', " + 
                                                                    "pass = '"+ MyDatabaseManager.EscapeCharacters(newpwdReceived) + "', " + 
                                                                    "email= '"+ MyDatabaseManager.EscapeCharacters(emailReceived) + 
                                                                    "' WHERE ID= "+session.getAttribute("userID") +";", connection);

                                connection.close();


                                session.setAttribute("userID", userID);
                                session.setAttribute("user", userReceived);
                                session.setAttribute("fname", nameReceived);
                                session.setAttribute("lname", surnameReceived);                    
                                session.setAttribute("errorMessage", Errors.resetError);
                                response.sendRedirect(request.getContextPath() + "/index.jsp");
                            }
                            else
                            {
                                session.setAttribute("email", userEmail);
                                session.setAttribute("errorMessage", Errors.usernameTaken);
                                session.setAttribute("userID", userID);   
                                connection.close();
                                response.sendRedirect(request.getContextPath() + "/userPage.jsp?v=Profile#profilo");
                            }

                    }
                    else{
                        session.setAttribute("email", userEmail);
                        session.setAttribute("errorMessage", Errors.wrongPassword);
                        session.setAttribute("userID", userID);   
                        connection.close();
                        response.sendRedirect(request.getContextPath() + "/userPage.jsp?v=Profile#profilo");

                    }
                }
                else
                {
                    session.setAttribute("errorMessage", Errors.emailAlreadyExists);
                    session.setAttribute("userID", userID);   
                    connection.close();
                    response.sendRedirect(request.getContextPath() + "/userPage.jsp?v=Profile#profilo");
                }
                connection.close();

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
