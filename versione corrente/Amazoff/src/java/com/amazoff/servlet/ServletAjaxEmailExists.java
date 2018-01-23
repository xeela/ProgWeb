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
            
            response.sendRedirect(request.getContextPath() + "/recuperoPasswordPage.jsp?s="+risposta);
        }catch (SQLException ex) {
            risposta = "false"; 
            response.sendRedirect(request.getContextPath() + "/recuperoPasswordPage.jsp?s="+risposta);
        }
    }
       
    protected boolean sendEmail(HttpServletRequest request, String email, String pwd)
    {
        String recipient = email; //"francesco.bruschetti@yahoo.it"; 
        String recipient = email;  
        String subject = "Richiesta reset password dimenticata";
        String content = "<a href=\"http://localhost:8080/Amazoff/ResetPassword.jsp?tmp="+ pwd +"\" >Clicca qui</a> per ripristinare la tua password"; //http://test.davidefarina.com:8080
        /** OSS: cosi funziona solo se si usa in locale. Quando la vorremo mettere sul server, va cambiato localhost, con http://test.davidefarina.com:8080 */
        String content = "<a href=\"http://localhost:8080/Amazoff/ResetPassword.jsp?tmp="+ pwd +"\" >Clicca qui</a> per ripristinare la tua password"; 
 
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
