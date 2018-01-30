<%@page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*,java.text.*" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Amazoff</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- *** senza questo, i col di bootstrap non funzionano correttamente *** -->
        <meta name="viewport" content="width=device-width, initial-scale=1"> 

        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="js/popper.js"></script>
        <script src="js/popper-utils.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>

        <link rel="stylesheet" href="css/amazoffStyle.css">

        <script type="text/javascript">
            var condizioniAccettate = false;
            function MostraErrore(text)
            {
                document.getElementById("alertRegistrati").innerHTML = "<strong>Errore!</strong> " + text;
                document.getElementById("alertRegistrati").style.visibility = "visible";
                console.log(text);
            }
            // NON VIENE CHIAMATO CORRETTAMENTE
            function checkDati()
            {
                var paese = $("#paese").val();
                var indirizzo = $("#indirizzo").val();
                var citta = $("#citta").val();
                var provincia = $("#provincia").val();
                var cap = $("#cap").val();
                //Controllo se le password sono valide, lunghezze dei campi etc
                if (paese.length == 0 || indirizzo.length == 0 || citta.length == 0
                        || provincia.length == 0 || cap.length == 0) {
                    MostraErrore("Completa i campi obbligatori prima di salvare");
                    return false;
                }
            }
        </script>

        <!-- STYLE STEPS BAR -->
        <style>
            .stepwizard-step p {
                margin-top: 10px;    
            }
            .stepwizard-row {
                display: table-row;
            }
            .stepwizard {
                display: table;     
                width: 100%;
                position: relative;
            }
            .stepwizard-step button[disabled] {
                opacity: 1 !important;
                filter: alpha(opacity=100) !important;
            }
            .stepwizard-row:before {
                top: 14px;
                bottom: 0;
                position: absolute;
                content: " ";
                width: 100%;
                height: 1px;
                background-color: #ccc;
                z-order: 0;
            }
            .stepwizard-step {    
                display: table-cell;
                text-align: center;
                position: relative;
            }
            .btn-circle {
                width: 30px;
                height: 30px;
                text-align: center;
                padding: 6px 0;
                font-size: 12px;
                line-height: 1.428571429;
                border-radius: 15px;
            }</style>
    </head>
    <body>                     
        <div class="container-fluid tmargin">

            <!-- STEPS PROGRESS -->
            <div class="stepwizard">
                <div class="stepwizard-row">
                    <div class="stepwizard-step">
                        <button type="button" class="btn btn-default btn-circle">1</button>
                        <p>Registrazione</p>
                    </div>
                    <div class="stepwizard-step">
                        <button type="button" class="btn btn-primary btn-circle">2</button>
                        <p>Dati Aggiuntivi</p>
                    </div>
                </div>
            </div>


            <!-- LOGO -->
            <div class="row" style="text-align: center">
                <div class="col-lg-12">
                    <img src="images/logo/logo.png" class="logo2" alt="Amazoff"/>
                </div>
            </div>

            <div class="col-lg-3"></div>

            <!-- AGGIUNGI NEGOZIO / CARTA DI CREDITO / VIA ... -->
            <div class="col-xs-12 col-lg-6" >
                <div class="row ">

                    <div>
                        <div class="row">
                            <h3 style="text-align: center">Aggiungi indirizzo:</h3>
                        </div>
                    </div>

                    <div class="col-xs-12">
                        <form class="form-group" id="LoginForm" name="FormIndirizzo" action="ServletDopoRegistrazione" method="POST" onsubmit="return checkDati();">
                            <input name="paese" type="text" class="form-control" placeholder="Paese (si può anche fare a meno)" aria-describedby="sizing-addon2">
                            <input name="indirizzo" type="text" class="form-control" placeholder="Indirizzo" aria-describedby="sizing-addon2">
                            <input name="citta" type="text" class="form-control" placeholder="Città" aria-describedby="sizing-addon2">
                            <input name="provincia" type="text" class="form-control" placeholder="Provincia" aria-describedby="sizing-addon2">
                            <input name="cap" type="number" class="form-control" placeholder="Codice postale" aria-describedby="sizing-addon2">

                            <input name="intestatario" type="text" class="form-control" placeholder="Intestatario" aria-describedby="sizing-addon2">
                            <input name="numerocarta" type="number" class="form-control" placeholder="Numero carta" aria-describedby="sizing-addon2">

                            <div style="align: left">Data di scadenza</div>
                            <div>
                                <div class="dropdown" style="display: inline-block">
                                    <select name="mesescadenza" class="btn btn-default dropdown-toggle" type="button" >
                                        <%
                                              String codice = "";
                                              for (int i = 1; i <= 12; i++)
                                              {
                                                  codice += "<option value=\""+i+"\">"+i+"</li>";
                                              }
                                        %>
                                        <%= codice %>
                                    </select>
                                </div>
                                <div class="dropdown" style="display: inline-block;align: rigth ">


                                    <select name="annoscadenza" class="btn btn-default dropdown-toggle" type="button" >
                                        <%
                                            codice = "";
                                            int year = new java.util.Date().getYear() + 1900 + 15;
                                            for (int i = 2017; i <= year; i++)
                                            {
                                                codice += "<option value=\""+i+"\">"+i+"</li>";
                                            }
                                        %>
                                        <%= codice %>

                                    </select>
                                </div>
                            </div>
                            <div style="margin-top: 10px">
                                <button class="btn btn-primary" type="submit">Salva</button>
                                <a href="ServletIndexProducts" class="btn btn-default" type="button">Aggiungi in seguito</a>
                            </div>


                        </form> 
                    </div>

                </div>
            </div> 


        </div>
    </body>
</html>