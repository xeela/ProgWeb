/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.amazoff.servlet;

import com.amazoff.classes.EmailUtility;
import com.amazoff.classes.MyDatabaseManager;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Francesco Bruschetti
 */
public class ServletAjaxEmailExists extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
        }
    private String host;
    private String port;
    private String user;
    private String pass;
 
    public void init() {
        // reads SMTP server setting from web.xml file
        ServletContext context = getServletContext();
        host = context.getInitParameter("host");
        port = context.getInitParameter("port");
        user = context.getInitParameter("user");
        pass = context.getInitParameter("pass");
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        
        String risposta = "false";
        try (PrintWriter out = response.getWriter()) {
        
            String emailReceived = request.getParameter("_email");

            HttpSession session = request.getSession();
            
            
            
            /** se l'oggetto MyDatabaseManager non esiste, vuol dire che la connessione al db non è presente */
            if(!MyDatabaseManager.alreadyExists) /** se non esiste lo creo */
            {
                MyDatabaseManager mydb = new MyDatabaseManager();
            }
        
            if(MyDatabaseManager.cpds != null)
            {
                Connection connection = MyDatabaseManager.CreateConnection();
                ResultSet results = MyDatabaseManager.EseguiQuery("SELECT email, passrecupero FROM users WHERE email = '" + MyDatabaseManager.EscapeCharacters(emailReceived) + "';", connection);
                
                if(results.isAfterLast()) 
                {
                    risposta = "false";
                }
                else {
                    risposta = "false";
                    while (results.next()) { // se esiste un utente con quella email, ritorno FALSE
                        risposta = "true&/Amazoff/ResetPassword.jsp?tmp="+results.getString(2);
                        //response.sendRedirect(request.getContextPath() + "/ResetPassword.jsp?tmp="+results.getString(2));
                    while (results.next()) { 
                        risposta = "true"; 
                        /** memorizzo l'email in una sessione */
                        session.setAttribute("recuperoEmail", emailReceived);
                        
                        /** chiamo la servlet che manda la email per il reset della password all'utente */
                        risposta = String.valueOf(sendEmail(request, emailReceived, results.getString(2)));
                        
                    }
                }
                connection.close();
            }
            else  // ritorno FALSE, c'è stato un errore
            {
                risposta = "false";
            }
            
            // ritorno il risultato alla pagina chiamante
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
            
            response.sendRedirect(request.getContextPath() + "/recuperoPasswordPage.jsp?s="+risposta);
        }catch (SQLException ex) {
           // ritorno FALSE, c'è stato un errore
            risposta = "false";
            response.setContentType("text/plain");
            response.getWriter().write(risposta);
            risposta = "false"; 
            response.sendRedirect(request.getContextPath() + "/recuperoPasswordPage.jsp?s="+risposta);
        }
    }
       
    protected boolean sendEmail(HttpServletRequest request, String email, String pwd)
    {
        String recipient = email; //"francesco.bruschetti@yahoo.it"; 
        String subject = "Richiesta reset password dimenticata";
        String content = "<a href=\"http://localhost:8080/Amazoff/ResetPassword.jsp?tmp="+ pwd +"\" >Clicca qui</a> per ripristinare la tua password"; //http://test.davidefarina.com:8080
 
        String resultMessage = "";
 
        try {
            EmailUtility.sendEmail(host, port, user, pass, recipient, subject,
                    content);
            //resultMessage = "The e-mail was sent successfully";
            //request.setAttribute("statoEmail", "1");
        } catch (Exception ex) {
            ex.printStackTrace();
            //resultMessage = "There were an error: " + ex.getMessage();
            //request.setAttribute("statoEmail", "0");
            return false;
        } /*finally {
            //request.setAttribute("Message", resultMessage);
            //getServletContext().getRequestDispatcher("/Result.jsp").forward(request, response);
        }*/
        
        return true;
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
