<%-- 
    Document   : orderCompletedPage
    Created on : 29-Oct-2017, 10:31:15
    Author     : Fra
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
        <!-- barra verticale vuota -->
        <div class="hidden-xs col-sm-4"></div>

        <div id="bodyPage" class="col-xs-12 col-sm-4" style="background-color: #33cc33">
            <h1 id="iconaOrdine"></h1>
            <h1 id="statoOrdine"></h1>
            <hr>
            <h4 id="id_ordine">ID ordine</h4>
            <h4 id='emailOrdine'>E' stata mandata una email di conferma dell'ordine</h4>
            <hr>
            <div>
                <p style="display: inline; align: left;"><b>Verrai reindirizzato alla Home tra: </b></p>
                <p style="display: inline; align: right;"><b id="timer">5 sec</b></p>
                <div>
                    <h3><a href="index.jsp" style="color: blue">Torna alla Home <span class="glyphicon glyphicon-home"></span></a></h3>
                </div>


                <script>
                    function startTimer()
                    {
                        var timeleft = 5;
                        var downloadTimer = setInterval(function () {
                            timeleft--;
                            document.getElementById("timer").textContent = timeleft + " sec";
                            // appena il tempo rimanente scende sotto lo 0, reindirizzo l'utente
                            if (timeleft <= 0) {
                                // fermo il timer
                                clearInterval(downloadTimer);
                                window.location = "index.jsp";
                            } else {
                            }
                        }, 1000);
                    }

                    // controllo il parametro in get
                    var stato = "<%=request.getParameter("p")%>";

                    // in base al parametro, creo il corpo della pagina
                    if (stato == "ok" && (stato != null && stato != "")) {
                        document.getElementById("statoOrdine").innerText = "Ordine completato correttamente";
                        document.getElementById("iconaOrdine").innerHTML = "<i class=\"fa fa-check\" aria-hidden=\"true\"></i>";
                        document.getElementById("bodyPage").style.backgroundColor = "#33cc33";
                        document.getElementById("emailOrdine").style.visibility = "visible";
                    } else
                    {
                        document.getElementById("statoOrdine").innerText = "Errore durante il completamento dell' ordine";
                        document.getElementById("iconaOrdine").innerHTML = "<i class=\"fa fa-close\" aria-hidden=\"true\"></i>";
                        document.getElementById("bodyPage").style.backgroundColor = "red";
                        document.getElementById("emailOrdine").style.visibility = "hidden";
                        $("#emailOrdine").remove();
                    }

                    startTimer();
                </script>
                </body>
                </html>
