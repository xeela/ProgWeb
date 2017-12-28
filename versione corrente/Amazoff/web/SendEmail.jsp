<%-- 
    Document   : SendEmail
    Created on : Nov 7, 2017, 1:49:15 PM
    Author     : Fra
--%>

<%@page import="com.amazoff.servlet.ServletSendEmail"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h1>Hello World!</h1>
        <p>Send Email (di prova)</p>
        <form action="ServletSendEmail" method="get">
            To:<input type="text" name="to" value="francesco.bruschetti@marconirovereto.it" /><br/>
            Subject:<input type="text" name="subject" value="subbbbb"/><br/>
            Message:<input type="text" name="message"  value="Messaggio di prova"/><br/>
            Your Email id:<input type="text" name="user" value="francesco.bruschetti@studenti.unitn.it"><br/>
            Password: <input type="password" name="pass"   /><br/>
            <input type="submit" value="send" />
        </form>
            
            
    </body>
</html>
