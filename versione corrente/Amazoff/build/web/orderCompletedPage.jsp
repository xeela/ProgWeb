<%-- 
    Document   : orderCompletedPage
    Created on : 29-Oct-2017, 10:31:15
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
                <div class="col-lg-8 col-lg-offset-2">
                    <div class="alert alert-success" id="div_alert" role="alert">
                        <h2 id="statoOrdine" class="alert-heading"></h2>
                        <hr>
                        <p id="id_ordine">ID ordine: <%=session.getAttribute("id")%></p>
                        <h4 id='messaggioOrdine'></h4>
                    </div>
                </div>
            </div>
        </div>

        <script>
                                
                    /** controllo i parametri ricevuti dalla servlet */
                    var stato = "<%=session.getAttribute("p")%>";

                    /** in base al parametro, creo il corpo della pagina */
                    if (stato == "ok" && (stato != null && stato != "")) {
                        document.getElementById("statoOrdine").innerText = "Ordine completato correttamente";
                        document.getElementById("messaggioOrdine").innerHTML = "E' stata mandata una notifica di conferma dell'ordine.";
                        $("#div_alert").attr('class','alert alert-success');      
                    } else
                    {
                        document.getElementById("statoOrdine").innerText = "Errore durante il completamento dell' ordine";
                        document.getElementById("messaggioOrdine").innerHTML = "<a href='index.jsp'><b>Clicca qui</b></a> per tornare alla home e riprovare.";
                        $("#div_alert").attr('class','alert alert-danger');  
                    }

        </script>
    </body>
</html>
