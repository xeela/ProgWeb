<%-- 
    Document   : SendEmail
    Created on : Nov 7, 2017, 1:49:15 PM
    Author     : Fra
--%>

<%@page import="com.amazoff.classes.SendEmail"%>
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
        <p>"RISP: <%=SendEmail.sendEmail() %></p>
            
            
    </body>
</html>
