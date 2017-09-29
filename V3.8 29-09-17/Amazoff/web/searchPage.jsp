<%-- 
    Document   : index
    Created on : 19-set-2017, 10.56.58
    Author     : Davide
--%>

<%@page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <script src="js/popper.js"></script>
        <script src="js/popper-utils.js"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle">
            
        <div class="container-fluid">
            
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <!-- row contenente il menu / searchbar e button vari -->
                <div class="row" > 
                        <!-- barra con: login/registrati, cerca, carrello -->
                        <div class="logo col-xs-12 col-lg-1">
                            <div class="row">
                                <div class="col-xs-8 col-lg-10"><a href="index.jsp">LOGO</a></div>
                                <div class="col-xs-2 hidden-lg" style="text-align: right"> 
                                    <a style="none" href="paginaUtenteDaCreare.jsp" id="iconAccediRegistrati"><spam class="glyphicon glyphicon-user"></spam></a>
                                    <% 
                                            try {
                                                    String user = (session.getAttribute("user")).toString();
   
                                                }catch(Exception ex){
                                            %>
                                                <script>document.getElementById("iconAccediRegistrati").href="loginPage.jsp";</script>
                                            <%
                                                }
                                             %>
                                
                                
                                </div>
                                <div class="col-xs-2 hidden-lg" style="text-align: right"> <spam class="glyphicon glyphicon-shopping-cart"></spam></div>
                            </div>
                        </div>
                        <!-- SEARCH BAR -->
                        <div class="searchBar col-xs-12 col-lg-7">
                            <div class="input-group">
                                
                                <input id="txtCerca" type="text" 
                                       class="form-control" aria-label="..." 
                                       placeholder="Cosa vuoi cercare?"
                                       value="<%
                                           if(request.getParameter("p") != null)
                                               out.println(request.getParameter("p")); %>" <!-- Se ho ricevuto un paramentro in GET, inserisco il valore nella barra di ricera -->

                                
                                <div class="input-group-btn">
                                  <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Scegli categoria<span class="caret"></span></button>
                                  <ul class="dropdown-menu dropdown-menu-left hidden-xs"> 
                                    <li><a href="#">Prodotto</a></li>
                                    <li><a href="#">Categoria</a></li>
                                    <li><a href="#">Luogo</a></li>
                                  </ul>
                                  <button class="btn btn-default" type="button">Cerca</button>
                                </div><!-- /btn-group --> 
                            </div><!-- /input-group -->
                        </div>                     
                        
                        <!-- button: accedi/registrati e carrello per PC -->
                        <div class="hidden-xs hidden-sm hidden-md col-lg-4">
                        
                            <div class="row">                                
                                <div class="dropdownUtente col-lg-6" >
                                    <div class="dropdown">
                                        <a href="paginaUtenteDaCreare.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
                                            <% 
                                                try {
                                                    String user = (session.getAttribute("user")).toString();
                                            %>
                                            <%= user %></a>
                                            <% 
                                                }catch(Exception ex){
                                            %>
                                                    Accedi / Registrati</a>
                                    
                                        <script>document.getElementById("btnAccediRegistrati").href="loginPage.jsp";</script>
                                            <%
                                                }
                                             %>
                                    </div>
                                </div>
                                
                                <div class="col-lg-4">
                                   <button type="button" class="btn btn-default btn-md">
                                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>
                                    </button>
                                </div>
                            </div>
                        </div>
                            
                        <!-- barra contenente scegli cat. tipi ordinamento e filtri, solo in disp xs -->
                        <div class="col-xs-12 hidden-sm hidden-md hidden-lg">
                            <div class="menuBar">
                                <div class="list-group">
                                    <!-- scegli categoria -->
                                    <div class="dropdown">
                                        <button class="list-group-item dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                          Scegli categoria <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                                          <li><a href="#">Categoria</a></li>
                                          <li><a href="#">Oggetto</a></li>
                                          <li><a href="#">Venditore</a></li>
                                        </ul>
                                    </div>
                                    <!-- ordina per -->
                                    <div class="dropdown">
                                        <button class="list-group-item dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                          Ordina per <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                                          <li><a href="#">Prezzo: crescente</a></li>
                                          <li><a href="#">Prezzo: decrescente</a></li>
                                          <li><a href="#">Recensione: crescente</a></li>
                                          <li><a href="#">Recensione: decrescente</a></li>
                                        </ul>
                                    </div>
                                    <!-- Filtra -->
                                    <div class="dropdown">
                                        <button class="list-group-item dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                          Filtra <span class="caret"></span>
                                        </button>
                                        <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                                          <li><a href="#">Vicinanza</a></li>
                                          <li><a href="#">Prezzo</a></li>
                                          <li><a href="#">Recensione</a></li>
                                        </ul>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                        
                        
                </div>
                                    
                <!-- barra verticale a sx contentente i filtri e metodi di ordinamento-->
                <div class="tmargin hidden-xs col-sm-2 col-lg-2">
                    <table class="table table-hover">
                        <tbody>
                            <tr><th>Filtri</th></tr>
                            <tr><td><a href="#">Vicinanza</a></td></tr>
                            <tr><td><a href="#">Prezzo</a></td></tr>
                            <tr><td><a href="#">Recensione</a></td></tr>
                        </tbody>
                    </table>
                    
                    <table class="table table-hover">
                        <tbody>
                            <tr><th>Ordina per:</th></tr>
                            <tr><td><a href="#">Costo: crescente</a></td></tr>
                            <tr><td><a href="#">Costo: decrescente</a></td></tr>
                            <tr><td><a href="#">Recensione: crescente</a></td></tr>
                            <tr><td><a href="#">Recensione: decrescente</a></td></tr>
                        </tbody>
                    </table>
                    
                </div>
                 
               <!-- corpo della pagina contenente i risultati della ricerca -->
               <div class="tmargin col-xs-12 col-sm-10">
                   <div class="row panel panel-default">         
                        <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                <div class="col-xs-4 col-sm-3 col-md-2"  style="background-color: green; margin: 0 0 0 0;">
                                    <!-- <img src="images/doge.jpg" alt="" > -->
                                    immagine
                                </div>
                                <div class="col-xs-8 col-sm-7 col-md-9">
                                    <p id="nome+" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->
                                    <p id="stelle+">Voto totale</p>
                                    <p id="recensioni+" >#num recensioni</p>
                                    <p id="linkmappa" >Vedi su mappa</p>
                                    <p id="prezzo+">Prezzo</p>
                                    <p id="venditore+" >Nome venditore <a href="url_venditore.html">Negozio</a></p>                                

                                </div>
                                <div class="hidden-xs col-sm-2 col-md-1" > <!-- style="background-color: aqua; position: absolute;" -->
                                    <span class="prova glyphicon glyphicon-chevron-right"></span>
                                </div>
                        </a>
                       
                   </div>
                   <div class="row panel panel-default">
                        <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                <div class="col-xs-4 col-sm-3 col-md-2"  style="background-color: green; margin: 0 0 0 0;">
                                    <!-- <img src="images/doge.jpg" alt="" > -->
                                    immagine
                                </div>
                                <div class="col-xs-8 col-sm-7 col-md-9">
                                    <p id="nome+" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->
                                    <p id="stelle+">Voto totale</p>
                                    <p id="recensioni+" >#num recensioni</p>
                                    <p id="linkmappa" >Vedi su mappa</p>
                                    <p id="prezzo+">Prezzo</p>
                                    <p id="venditore+" >Nome venditore <a href="url_venditore.html">Negozio</a></p>                                

                                </div>
                                <div class="hidden-xs col-sm-2 col-md-1" > <!-- style="background-color: aqua; position: absolute;" -->
                                    <span class="prova glyphicon glyphicon-chevron-right"></span>
                                </div>
                        </a>
                   </div>
                   <div class="row panel panel-default" style="background-color: aqua;">
                         <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                <div class="col-xs-4 col-sm-3 col-md-2"  style="background-color: green; margin: 0 0 0 0;">
                                    <!-- <img src="images/doge.jpg" alt="" > -->
                                    immagine
                                </div>
                                <div class="col-xs-8 col-sm-7 col-md-9">
                                    <p id="nome+" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->
                                    <p id="stelle+">Voto totale</p>
                                    <p id="recensioni+" >#num recensioni</p>
                                    <p id="linkmappa" >Vedi su mappa</p>
                                    <p id="prezzo+">Prezzo</p>
                                    <p id="venditore+" >Nome venditore <a href="url_venditore.html">Negozio</a></p>                                

                                </div>
                                <div class="hidden-xs col-sm-2 col-md-1" > <!-- style="background-color: aqua; position: absolute;" -->
                                    <span class="prova glyphicon glyphicon-chevron-right"></span>
                                </div>
                        </a>
                   </div>
                </div>                    
                

                <!-- barra bianca a dx -->
                <div class="hidden-xs col-lg-1"></div>

                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer -- MANDA TUTTO A PUTTANTE.
                <footer style="background-color: red">
                    <p>&copy; Company 2017</p>
                </footer> -->
            
            </div>
        </div>
            
            
            
        <script>
            // When the user scrolls down 20px from the top of the document, show the button
            window.onscroll = function() {scrollFunction()};

            function scrollFunction() {
                if (document.body.scrollTop > 20 || document.documentElement.scrollTop > 20) {
                    document.getElementById("btnTop").style.display = "block";
                } else {
                    document.getElementById("btnTop").style.display = "none";
                }
            }

            // When the user clicks on the button, scroll to the top of the document
            function topFunction() {
                document.body.scrollTop = 0; // For Chrome, Safari and Opera 
                document.documentElement.scrollTop = 0; // For IE and Firefox
            }
            
        </script>
    </body>
</html>
