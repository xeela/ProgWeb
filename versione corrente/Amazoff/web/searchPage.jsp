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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css" />
        <script type="text/javascript">
            var jsonProdotti;
            var searchedProduct = null;
            function LogJson() {
                jsonProdotti = ${jsonProdotti};
                console.log(jsonProdotti);
                RiempiBarraRicerca();
                AggiungiProdotti();
            }
            
            function AggiungiProdotti() {
                var toAdd = "";
                var id_oggetto = -1
                
                for(var i = 0; i < jsonProdotti.products.length; i++)
                {
                    id_oggetto = jsonProdotti.products[i].id;
                    toAdd += "<div class=\"row\">";
                    toAdd += "<form method=\"post\" action=\"/Amazoff/ServletPopulateProductPage?id="+id_oggetto+"\" id=\"form"+id_oggetto+"\" onclick=\"$('#form"+id_oggetto+"').submit();\"> ";
                    toAdd += "<div class=\"thumbnail col-xs-4 col-sm-3 col-md-2\" style=\"min-height:100px;  \">";
                    toAdd += "   <img src=\"UploadedImages/"+ jsonProdotti.products[i].pictures[0].path + "\" style=\"max-height: 100px; \" alt=\"...\">";
                    toAdd += "</div>";
                    toAdd += "<div class=\"col-xs-8 col-sm-7 col-md-9\">";
                    toAdd += "<p name=\"nome"+id_oggetto+"\" >" + jsonProdotti.products[i].name + "</p>";
                    toAdd += "<p name=\"stelle"+id_oggetto+"\">Voto totale</p>";
                    toAdd += "<p name=\"recensioni"+id_oggetto+"\" >#num recensioni</p>";
                    toAdd += "<p name=\"linkmappa"+id_oggetto+"\" >Vedi su mappa</p>";
                    toAdd += "<p name=\"prezzo"+id_oggetto+"\">Prezzo: " + jsonProdotti.products[i].price + "</p>";
                    toAdd += "<p name=\"venditore"+id_oggetto+"\" >Nome venditore <a href=\"url_venditore.html\">Negozio</a></p>";       
                    toAdd += "</div>";
                    toAdd += "<div class=\"hidden-xs col-sm-2 col-md-1\" >";
                    toAdd += "<span class=\"prova glyphicon glyphicon-chevron-right\"></span>";
                    toAdd += "</div>";
                    toAdd += "</form><hr>";
                }
                
                $("#zonaProdotti").html(toAdd);
            }
            
            function RiempiBarraRicerca()
            {
                searchedProduct = jsonProdotti.searched;
                $("#txtCerca").val(searchedProduct);
            }
            
            /*// dato un elemento text input, reindirizza alla pagina searchPage passando in get il valore nella txt
            function cercaProdotto(txt)
            {
                window.location = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value;
            }*/
            
        </script>
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle" onload="LogJson()">
            
        <div class="container-fluid tmargin">
            
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <!-- row contenente il menu / searchbar e button vari -->
                <div class="row" > 
                        <!-- barra con: login/registrati, cerca, carrello -->
                        <div class="logo col-xs-12 col-lg-1">
                            <div class="row">
                                <div class="col-xs-6 col-lg-10"><a href="index.jsp">
                                        <img src="images/logo/logo.png" alt="Amazoff"/>
                                    </a></div>
                                <div class="col-xs-2 hidden-lg" style="text-align: right"> 
                                    <a style="none" class="dropdown" href="userPage.jsp" id="iconAccediRegistrati"><spam class="glyphicon glyphicon-user"></spam></a>
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
                                 
                                <!-- nel caso in cui l'utente sia venditore o admin, visualizzo il btn NOTIFICHE -->
                                <% 
                                    String userType = "";
                                    try {
                                            userType = (session.getAttribute("categoria_user")).toString();
                                            if(userType.equals("1") || userType.equals("2"))
                                            {
                                                %>
                                                <div class="col-xs-2 hidden-lg" style="text-align: right;">
                                                    <span class="badge"><a href="notificationPage.jsp"> <spam class="glyphicon glyphicon-inbox"></spam> 11</a></span>
                                                 </div>
                                                <%
                                            }
                                        }catch(Exception ex){   }
                                %> 
                                <div class="col-xs-2 hidden-lg" style="text-align: right"> <a href="shopping-cartPage.jsp"> <spam class="glyphicon glyphicon-shopping-cart"></spam></a></div>
                            </div>
                        </div>
                        <!-- SEARCH BAR -->
                        <div class="searchBar col-xs-12 col-lg-7">
                            <div>
                                <form id="formSearch" class="input-group" method="get" action="/Amazoff/ServletFindProduct" >
                                    <div class="input-group-btn">
                                      <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Filtri <span class="caret"></span></button>
                                      <ul class="dropdown-menu dropdown-menu-left hidden-xs"> 
                                        <li><a href="#">Vicinanza</a></li>
                                        <li><a href="#">Prezzo</a></li>
                                        <li><a href="#">Recensione</a></li>
                                      </ul>
                                    </div>

                                    <input id="txtCerca" name="txtCerca" type="text" class="form-control" aria-label="..." placeholder="Cosa vuoi cercare?">

                                    <div class="input-group-btn">
                                    <select class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="search_category">Select category<span class="caret"></span></button>
                                        <option value="product">Product</option>
                                        <option value="seller">Seller</option>
                                    </select>
                                      <button class="btn btn-default" type="submit">Cerca</button> <!-- **** onclick è temporaneo, andrà sostituito con la chiamanta alla servlet che genera la pagina search in base al dato passato -->
                                    </div><!-- /btn-group --> 
                                </form>
                            </div><!-- /input-group -->
                        </div>                     
                        
                        <!-- button: accedi/registrati e carrello per PC -->
                        <div class="hidden-xs hidden-sm hidden-md col-lg-4">
                        
                            <div class="row">                                
                                <div class="dropdownUtente col-lg-7" >
                                    <div class="btn-group">
                                        <a href="profilePage.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
                                            <% 
                                                userType = "";
                                                String fname = "", lname = "";
                                                try {
                                                    String user = (session.getAttribute("user")).toString();
                                                    userType = (session.getAttribute("categoria_user")).toString();
                                                    fname = (session.getAttribute("fname")).toString();
                                                    lname = (session.getAttribute("lname")).toString();
                                            %>
                                            <%= fname + " " + lname %>
                                            <% 
                                                }catch(Exception ex){
                                            %>
                                                    Accedi / Registrati
                                    
                                        <script>document.getElementById("btnAccediRegistrati").href="loginPage.jsp";</script>
                                            <%
                                                }
                                             %>
                                        </a>      
                                            <!-- menu a tendina con le azioni che può fare l'utente -->
                                            <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                              <span class="caret"></span>
                                            </button>
                                            <ul class="dropdown-menu">
                                                <%
                                                    if(userType.equals("0")) // registrato
                                                    {
                                                        %>
                                                        <li><a href="profilePage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Rimborso / Anomalia</a></li>
                                                        <li><a href=".jsp">Diventa venditore</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("1")) // venditore
                                                    {
                                                        %>
                                                        <li><a href="profilePage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Notifiche</a></li>
                                                        <li><a href=".jsp">Negozio</a></li>
                                                        <li><a href="sellNewProduct.jsp">Vendi Prodotto</a></li>
                                                        <li><a href=".jsp">Gestisci prodotti</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("2")) //admin
                                                    {
                                                        %>
                                                        <li><a href="profilePage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Notifiche</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else { %>
                                                        <li><a href="loginPage.jsp">Accedi</a></li>
                                                        <li><a href="loginPage.jsp">Registrati</a></li>
                                                   <% }
                                                %>
                                                
                                            </ul> 
                                    </div>
                                </div>
                                                
                                <!-- nel caso in cui l'utente sia venditore o admin, visualizzo il btn NOTIFICHE -->
                                     <% try {
                                            //userType = (session.getAttribute("categoria_user")).toString();
                                            if(userType.equals("1") || userType.equals("2"))
                                            {
                                                %>
                                                <div class="col-lg-3">
                                                    <a href="notificationPage.jsp" type="button" class="btn btn-default btn-md">
                                                        <span class="badge"><span class="glyphicon glyphicon-inbox" aria-hidden="true"></span> 11</span>
                                                     </a>
                                                 </div> 
                                                <%
                                            }
                                        }catch(Exception ex){  }
                                   %>
                                
                                <div class="col-lg-2">
                                   <a href="shopping-cartPage.jsp" type="button" class="btn btn-default btn-md">
                                        <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>
                                    </a>
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
               <div class="tmargin col-xs-12 col-sm-10" id="zonaProdotti">
                   <!-- LAYOUT --
                   <div class="row panel panel-default">      
                        <form method="post" action="/Amazoff/ServletPopulateProductPage" id="formid_oggetto" onclick="$('#formid_oggetto').submit();">
                                <div class="col-xs-4 col-sm-3 col-md-2"  style="background-color: green; ">
                                    <!-- <img src="images/doge.jpg" alt="" > --
                                    immagine
                                </div>
                                <div class="col-xs-8 col-sm-7 col-md-9">
                                    <p id="nome+" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto--
                                    <p id="stelle+">Voto totale</p>
                                    <p id="recensioni+" >#num recensioni</p>
                                    <p id="linkmappa" >Vedi su mappa</p>
                                    <p id="prezzo+">Prezzo</p>
                                    <p id="venditore+" >Nome venditore <a href="url_venditore.html">Negozio</a></p>                                

                                </div>
                                <div class="hidden-xs col-sm-2 col-md-1" > 
                                    <span  class="glyphicon glyphicon-chevron-right"></span>
                                </div>
                        </form>
                       <hr>
                   </div> -->
                   
                </div> 
               
                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer ROMPE TUTTO--
                <footer style="background-color: red">
                    <p>&copy; Company 2017</p>
                </footer> -->
            
            </div>
            <!-- barra bianca a dx -->
            <div class="hidden-xs col-lg-1"></div>
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
