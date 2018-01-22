package com.amazoff.servlet;

import com.amazoff.classes.EmailUtility;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author Francesco Bruschetti
 */
@WebServlet("/EmailSendingServlet")
public class EmailSendingServlet extends HttpServlet {
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
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        
        // reads form fields
        String e = request.getAttribute("_email").toString();
        String x = request.getAttribute("pwdRecupero").toString();
        String recipient = "francesco.bruschetti@yahoo.it"; // request.getParameter("recipient");
        String subject = "Richiesta reset password dimenticata"; //request.getParameter("subject");
        String content = "<a href=\"/Amazoff/ResetPassword.jsp?tmp="+x+"\" >Clicca qui</a> per ripristinare la tua password"; //request.getParameter("content");
 
        String resultMessage = "";
 
        try {
            EmailUtility.sendEmail(host, port, user, pass, recipient, subject,
                    content);
            resultMessage = "The e-mail was sent successfully";
            request.setAttribute("statoEmail", "1");
        } catch (Exception ex) {
            ex.printStackTrace();
            resultMessage = "There were an error: " + ex.getMessage();
            request.setAttribute("statoEmail", "0");
        } finally {
            request.setAttribute("Message", resultMessage);
            //getServletContext().getRequestDispatcher("/Result.jsp").forward(request, response);
        }
    }
}
