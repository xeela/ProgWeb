<%-- 
    Document   : recuperoPasswordPage
    Created on : 22-Jan-2018, 13:35:45
    Author     : Francesco Bruschetti
--%>

<%@page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="css/bootstrap-theme.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <link rel="stylesheet" href="css/amazoffStyle.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />

        <title>Amazoff</title>
    </head>
    <body>
        <nav class="navbar navbar-light bg-faded">
            <a class="navbar-brand" href="index.jsp"><span class="glyphicon glyphicon-home"></span> Torna alla Home </a>
        </nav> 

        <div class="container-fluid">
            <div class="row" style="text-align: center">
                <div class="col-lg-12">
                    <img src="images/logo/logo.png" class="logo2" alt="Amazoff"/>
                </div>
            </div>
            <br>
            <!-- corpo della pagina -->
            <div class="row" style="text-align: center">
                <div class="col-lg-8 col-lg-offset-2" id="div_alert">
                </div>
            </div>
        </div>
        
        <script>
            var stato = "<%=request.getParameter("s")%>";
            var email = "<%=session.getAttribute("recuperoEmail")%>";
            
            var errore = "<div class=\"alert alert-danger\" role=\"alert\"><strong>Errore!<strong> Si è verificato un errore durante la procedura di recupero della password. <a href=\"loginPage.jsp\" class=\"alert-link\">Clicca qui per riprovare</a>. (Controlla di aver inserito correttamente la email)</div>";
            var successo = "<div class=\"alert alert-success\" role=\"alert\">Ti è stata inviata una email, all'indirizzo specificato, dalla quale potrai procedere al ripristino della password. <br> Email non ricevuta? <a href=\"ServletAjaxEmailExists?_email="+email+"\" class=\"alert-link\">Clicca qui</a></div>";
            
            
            if (stato == "true" && (stato != null && stato != "")) {
                document.getElementById("div_alert").innerHTML = successo;
            } else
            {
                document.getElementById("div_alert").innerHTML = errore;
            }
        </script>
    </body>
</html>
