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
        <link rel="stylesheet" href="css/bootstrap-theme.css">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>

        <!-- non va piu il popover 
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script> -->
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        <script type="text/javascript" src="js/parametri-ricerca.js"></script>

        <link rel="stylesheet" href="css/amazoffStyle.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
        <title>Amazoff</title>
        <script type="text/javascript">
            var jsonProdotti;
            var searchedProduct = null;
            
            function LogJson() {
                jsonProdotti = ${jsonProdottiIndex};
                console.log(jsonProdotti);
                RiempiBarraRicerca();
                AggiungiProdotti();
                Autocomplete("product");
            }
            
            function AggiungiProdotti() {
                var toAdd = "";
                var id_oggetto = - 1;

                for (var i = 0; i < jsonProdotti.products.length; i++)
                {
                    id_oggetto = jsonProdotti.products[i].id;
                    toAdd += "<div class=\"col-sm-6 col-md-4\">";
                    toAdd += "<div class=\"thumbnail\">";
                    toAdd += "<img class=\"imgResize\" src=\"UploadedImages/" + jsonProdotti.products[i].pictures[0].path + "\" alt=\"...\">";
                    toAdd += "<div class=\"caption\">";
                    toAdd += "<h3>" + jsonProdotti.products[i].name + "</h3>";
                    toAdd += "<h4>" + jsonProdotti.products[i].price + "€</h4>";
                    toAdd += "<p><a href=\"ServletPopulateProductPage?id="+jsonProdotti.products[i].id+"\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"/Amazoff/ServletAddToCart?productID=" + jsonProdotti.products[i].id + "\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>";
                    toAdd += "</div>";
                    toAdd += "</div>";
                    toAdd += "</div>";
                }

                $("#zonaProdotti").html(toAdd);
            }

            function RiempiBarraRicerca()
            {
                searchedProduct = jsonProdotti.searched;
                $("#txtCerca").val(searchedProduct);
            }
            
            $(document).ready(function() {
                $("#carouselNegozi").click( function(){
                    if (navigator.geolocation) {
                        navigator.geolocation.getCurrentPosition(redirectWithPosition);
                    } else {
                        alert("Geolocation is not supported by this browser");
                    }
                });
                
                function redirectWithPosition(position){
                    var lat = position.coords.latitude;
                    var lng = position.coords.longitude;
                    
                    window.location.href = 'ServletFindShops?userLat=' + lat + "&userLng=" + lng;
                }
            });
            </script>
    
    </head>
<body class="bodyStyle" onload="LogJson()">
       
<div class="container-fluid tmargin">
    <!-- barra bianca a sx -->
    <div class="hidden-xs col-lg-1"></div>

    <div class="col-xs-12 col-lg-10">

        <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
            <!-- barra con: login/registrati, cerca, carrello -->
            <div class="logo col-xs-12 col-lg-1"  >
                <div class="row">
                    <div class="col-xs-5 col-lg-12" >
                        <a href="index.jsp">
                            <img class="logo2" src="images/logo/logo.png" alt="Amazoff"/>
                        </a>
                    </div>
                    <div class="col-xs-7 hidden-lg" > <!-- Stile per centrare i button non va -->
                        <div class="col-xs-3 hidden-lg iconSize imgCenter" > 
                            <a class="dropdown" href="userPage.jsp" id="iconAccediRegistrati">
                                <spam class="glyphicon glyphicon-user"> 
                                    <%
                                        try {
                                            String user = (session.getAttribute("user")).toString();

                                        } catch (Exception ex) {
                                    %>
                                    Accedi 
                                    <script>document.getElementById("iconAccediRegistrati").href="loginPage.jsp";</script>

                                    <%
                                        }
                                    %>
                                </spam>
                            </a>
                        </div>

    <div class="col-xs-6 hidden-lg">
        <!-- nel caso in cui l'utente sia venditore o admin, visualizzo il btn NOTIFICHE -->
        <%
            String userType = "";
            try {
                userType = (session.getAttribute("categoria_user")).toString();
                if (userType.equals("1") || userType.equals("2")) {
        %>
        <a href="notificationPage.jsp">
            <span class="badge iconSize imgCenter" id="totNotifichexs"> 
                <spam class="glyphicon glyphicon-inbox"></spam>
                99+
            </span>
        </a>

        <%
                }
            } catch (Exception ex) {
            }
        %> 
    </div>                    

    <div class="col-xs-3 hidden-lg iconSize imgCenter" >
        <a href="ServletShowCart">
            <spam class="glyphicon glyphicon-shopping-cart"></spam>
        </a>
    </div>

    </div>
    </div>
    </div>

    <!-- SEARCH BAR -->
    <div class="searchBar col-xs-12 col-lg-7">
        <div>
            <form id="formSearch" class="input-group" method="get" action="/Amazoff/ServletFindProduct" >
                <div class="input-group-btn">                                        
                    <div role="tablist" aria-multiselectable="true">
                        <a type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="collapse" data-parent="#accordion"
                           href="#collapseFilter" aria-expanded="false "  aria-haspopup="true"
                           aria-controls="collapseFilter" >
                            <span class="glyphicon glyphicon-filter"></span>
                        </a>
                    </div>
                </div>

                <input id="txtCerca" name="txtCerca" type="text" class="form-control" aria-label="..." placeholder="Cosa vuoi cercare?">

                <div id="parametriRicerca">
                    <input id="categoriaRicerca" name="categoriaRicerca" type="text" style="display:none;" value="product">
                </div>

                <div class="input-group-btn">
                    <a type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="collapse" data-parent="#accordion"
                       href="#collapseFilter" aria-expanded="false "  aria-haspopup="true"
                       aria-controls="collapseFilter" >
                        Scegli categoria<span class="caret"></span>
                    </a>

                    <button class="btn btn-default" type="submit">Cerca</button>
                </div><!-- /btn-group --> 
            </form>

        </div><!-- /input-group -->
    </div> 

    <!-- button: accedi/registrati e carrello per PC -->
    <div class="hidden-xs hidden-sm hidden-md col-lg-4">

        <div class="row">                                
            <div class="dropdownUtente col-lg-7" >
                <div class="btn-group">
                    <a href="userPage.jsp" class="btn btn-default maxlength dotsEndSentence" type="button" id="btnAccediRegistrati" >
                        <%
                            userType = "";
                            String user = "", fname = "", lname = "";
                            try {
                                //user = (session.getAttribute("user")).toString();
                                userType = (session.getAttribute("categoria_user")).toString();
                                fname = (session.getAttribute("fname")).toString();
                                lname = (session.getAttribute("lname")).toString();
                        %>
                        <%= fname + " " + lname%>
                        <%
                        } catch (Exception ex) {
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
                            if (userType.equals("0")) // registrato
                            {
                        %>
                        <!-- PER ORA: se metto anche #profile, la pagina non si carica sull'oggetto con quel tag, ne prende i valori in get -->
                        <li><a href="userPage.jsp?v=Profilo#profilo">Profilo</a></li>
                        <li><a href="userPage.jsp">Rimborso / Anomalia</a></li>
                        <li><a href="userPage.jsp?v=CreateShop#createshop">Diventa venditore</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                            <%
                            } else if (userType.equals("1")) // venditore
                            {
                            %>
                        <li><a href="userPage.jsp?v=Profilo#profilo">Profilo</a></li>
                        <li><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche">Notifiche</a></li>
                        <li><a href="userPage.jsp">Negozio</a></li>
                        <li><a href="userPage.jsp?v=SellNewProduct#sellNewProduct">Vendi Prodotto</a></li>
                        <li><a href="userPage.jsp?v=GestisciProdotti#gestisciProdotti">Gestisci prodotti</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                            <%
                            } else if (userType.equals("2")) //admin
                            {
                            %>
                        <li><a href="userPage.jsp?v=Profilo#profilo">Profilo</a></li>
                        <li><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche">Notifiche</a></li>
                        <li role="separator" class="divider"></li>
                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                            <%
                                                            } else { %>
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
                    if (userType.equals("1") || userType.equals("2")) {
            %>
            <div class="col-lg-3">
                <a href="notificationPage.jsp" type="button" class="btn btn-default btn-md">
                    <span class="badge"><span class="glyphicon glyphicon-inbox" aria-hidden="true"></span> 11</span>
                </a> 

                <!-- prova ok  <button class="btn " title="Notifiche" data-container="body" data-toggle="popover" data-html="true" data-placement="bottom" data-content="<div>This <b>is</b> your div content</div>">
                  Popover on bottom
                </button> -->
            </div> 
            <%
                    }
                } catch (Exception ex) {
                }
            %> 


            <div class="col-lg-2">
                <a href="shopping-cartPage.jsp" type="button" class="btn btn-default btn-md">
                    <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>
                </a>
            </div>
        </div>
    </div>

    <!-- DIV FILTRI e CATEGORIE -->
    <div name="filters" class="hidden-xs col-sm-12 col-md-12 col-lg-12 tmargin">
        <div id="collapseFilter" class="panel-collapse collapse out" > 
            <div class="row">
                <div class="col-sm-6 col-lg-6" style="border-right: 2px #8c8c8c solid; ">
                    <h3 class="alignCenter">Filtri</h3>
                    <hr>
                    <ul class="no_dots"> 
                        <li>Vicinanza
                            <p>
                                <input class="form-control" type="number" min="0" step="1" placeholder="KM Max" name="distanzaMax" onchange="impostaDistanza(this)" onkeypress="return isNumberKey(event)"> 
                            </p>
                        </li>
                        <li>Prezzo
                            <p>
                                <input class="form-control" type="number" min="0" step="1" placeholder="Da..." id="prezzoDa" onchange="impostaMin(this)" onkeypress="return isNumberKey(event)">
                                <input class="form-control" type="number" min="0" step="1" placeholder="A..." id="prezzoA" onchange="impostaMax(this)" onkeypress="return isNumberKey(event)">
                            </p>
                        </li>
                        <li>Recensione
                            <p>
                                <input type="radio" value="all" name="filtro" checked="checked" onclick="impostaRecensione('all')"> tutte 
                                <input type="radio" value="5stelle" name="filtro" onclick="impostaRecensione('5')"> 5 stelle 
                                <input type="radio" value="4stelle" name="filtro" onclick="impostaRecensione('4')"> 4 stelle 
                                <input type="radio" value="3stelle" name="filtro" onclick="impostaRecensione('3')"> 3 stelle 
                                <input type="radio" value="2stelle" name="filtro" onclick="impostaRecensione('2')"> 2 stelle 
                                <input type="radio" value="1stella" name="filtro" onclick="impostaRecensione('1')"> 1 stella 
                            </p>
                        </li>
                    </ul>
                </div>
                <div class="col-sm-6 col-lg-6">
                    <h3 class="alignCenter">Categorie</h3>
                    <hr>
                    <ul class="no_dots"> 
                        <li><input type="radio" value="product" id="product" name="categoria" checked="checked" onclick="RadioSwitch('product')"> Oggetto</li>
                        <li><input type="radio" value="seller" id="seller" name="categoria" onclick="RadioSwitch('seller')"> Venditore</li>
                        <li><input type="radio" value="category" id="category" name="categoria" onclick="RadioSwitch('category')"> Categoria</li>
                  </ul>
                </div>
            </div>  
        </div>
        </div>

        <!-- DIV FILTRI e CATEGORIE SU XS -->
        <div class="col-xs-12 hidden-sm hidden-md hidden-lg">
            <div class="menuBar">
                <nav class="navbar navbar-default">
                    <div class="container">
                        <div class="row">
                            <div class="navbar-header col-xs-6">
                                <a class="btn navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                    Filtri <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-right hidden-sm hidden-md hidden-lg alignCenter"> <!-- ?????????? sull'ipad non sparisce -->
                                    <li>Vicinanza
                                        <p>
                                            <input class="form-control" type="number" min="0" step="1" placeholder="KM Max" name="distanzaMax" onchange="impostaDistanza(this)" onkeypress="return isNumberKey(event)"> 
                                        </p>
                                    </li>
                                    <li>Prezzo 
                                        <p>
                                            <input class="form-control" type="number" min="0" step="1" placeholder="Da..." id="prezzoDa" onchange="impostaMin(this)" onkeypress="return isNumberKey(event)">
                                            <input class="form-control" type="number" min="0" step="1" placeholder="A..." id="prezzoA" onchange="impostaMax(this)" onkeypress="return isNumberKey(event)">
                                        </p>
                                    </li>
                                    <li>Recensione
                                        <p>
                                            <input type="radio" value="all" name="filtro_xs" onclick="impostaRecensione('all')"> tutte 
                                            <input type="radio" value="5stelle" name="filtro_xs" onclick="impostaRecensione('5')"> 5 stelle 
                                            <input type="radio" value="4stelle" name="filtro_xs" onclick="impostaRecensione('4')"> 4 stelle 
                                            <input type="radio" value="3stelle" name="filtro_xs" onclick="impostaRecensione('3')"> 3 stelle 
                                            <input type="radio" value="2stelle" name="filtro_xs" onclick="impostaRecensione('2')"> 2 stelle 
                                            <input type="radio" value="1stella" name="filtro_xs" onclick="impostaRecensione('1')"> 1 stella 
                                        </p>
                                    </li>
                                </ul>
                            </div>
                            <div class="navbar-header col-xs-6">
                                <a class="btn navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                    Scegli categoria <span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-left col-xs-8 hidden-sm hidden-md hidden-lg"> <!-- ?????????? sull'ipad non sparisce -->
                                    <li><a href="#"><input type="radio" value="product" id="product_xs" name="categoria_xs" checked="checked" onclick="RadioSwitch('product')"> Oggetto</a></li>
                                    <li><a href="#"><input type="radio" value="seller" id="seller_xs" name="categoria_xs" onclick="RadioSwitch('seller')"> Venditore</a></li>
                                    <li><a href="#"><input type="radio" value="category" id="category_xs" name="categoria_xs" onclick="RadioSwitch('category')"> Categoria</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </nav>
            </div>
        </div>
    </div>

    <!-- carousel -->
    <div class="panel row tmargin hidden-xs">
        <div class="col-lg-12">
            <div id="myCarousel" class="carousel slide" data-ride="carousel">
                <!-- Indicators --
                <ol class="carousel-indicators">
                  <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                  <li data-target="#myCarousel" data-slide-to="1"></li>
                  <li data-target="#myCarousel" data-slide-to="2"></li>
                </ol>-->

                <!-- Wrapper for slides -->
                <div class="carousel-inner" role="listbox">

                    <div class="item active">
                        <a id="carouselNegozi" role="button">
                          <img src="images/trova_venditori.jpg" alt="Trova i venditori">
                        </a>
                        <!--<div class="carousel-caption">
                          <h3>Chania</h3>
                          <p>The atmosphere in Chania has a touch of Florence and Venice.</p>
                        </div>-->
                    </div>

                    <div class="item">
                      <img src="images/tecnologia.jpg" alt="Chania">
                    </div>

                    <div class="item">
                        <img src="images/diventa_venditore.jpg" alt="Chania">
                    </div>

                </div>

                <!-- Left and right controls -->
                <a class="left carousel-control col-lg-2" href="#myCarousel" role="button" data-slide="prev">
                  <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control col-lg-2" href="#myCarousel" role="button" data-slide="next">
                  <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
            </div>
        </div>
    </div>

    <!-- tabella di 2 righe, con 3 colonne, che mostrano 6 prodotti -->
    <div class="row">
        <div class="page" id="zonaProdotti">

        </div>
    </div>

    <!-- back to top button -->
    <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

    <!-- footer -->
    <footer style="background-color: #fc5d5d">
                    <div class="row">
                        <div class="col-xs-8 col-sm-4"><h5><b>Pagine</b></h5>
                            <p><a href="index.jsp"><span class="glyphicon glyphicon-menu-right"></span> Home</a></p>
                            <p><a href="searchPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Cerca prodotto</a></p> 
                            <p><a href="....."><span class="glyphicon glyphicon-menu-right"></span> Carrello</a></p> 
                            <!-- UTENTE SE "REGISTRATO" -> porta alla pag. ALTRIM. passa per la login -->
                               <%
                                   if (userType.equals("0")) // registrato
                                   {
                               %>
                               <p><a href="userPage.jsp?v=Profilo#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                        <p><a href="userPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Rimborso / Anomalia</a></p>
                        <p><a href="userPage.jsp?v=CreateShop#createshop"><span class="glyphicon glyphicon-menu-right"></span> Diventa venditore</a></p>
                        <!-- NON SO SE SERVE. In teoria si. SE si va aggiunto anche nei menu a tendina -->
                        <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>

                        <%  } else if (userType.equals("1")) // venditore
                            {  %>
                        <!-- UTENTE SE "VENDITORE" -> porta alla pag. ALTRIM. passa per la login -->
                        <p><a href="userPage.jsp?v=Profilo#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                        <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>
                        <p><a href="userPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Negozio</a></p>
                        <p><a href="userPage.jsp?v=SellNewProduct#sellNewProduct"><span class="glyphicon glyphicon-menu-right"></span> Vendi Prodotto</a></p>
                        <p><a href="userPage.jsp?v=GestisciProdotti#gestisciProdotti"><span class="glyphicon glyphicon-menu-right"></span> Gestisci prodotti</a></p>
                        <%  } else if (userType.equals("2")) // admin
                            {  %> 
                        <p><a href="userPage.jsp?v=Profilo#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                        <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>
                        <%  } else // non loggato
                            {  %>    
                        <p><a href="loginPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Accedi</a></p>
                        <p><a href="loginPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Registrati</a></p>
                        <%  }%>        
                        </div>
                        <div class="hidden-xs col-sm-4"><h5><b>Categorie</b></h5>
                            <p><a href="index.jsp"><span class="glyphicon glyphicon-menu-right"></span> Oggetto</a></p>
                            <p><a href="searchPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Venditore</a></p>
                        </div>

                        <div class="col-xs-4"><h5><b>Logout</b></h5>
                            <p><a href="ServletLogout"><span class="glyphicon glyphicon-menu-right"></span> ESCI</a></p>
                        </div>
                        </div>
                        <div class="row col-xs-12">
                            <p>&copy; Amazoff 2017 - info@amazoff.com - via di Amazoff 69, Trento, Italia</p>
                        </div>
    </footer>

    </div>

        <!-- barra bianca a dx -->
        <div class="hidden-xs col-lg-1"></div>                                    
        </div>



        <script>
            // When the user scrolls down 20px from t                            he top of the document, show the button
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
                        
            // dato un elemento text input, reindirizza alla pagina searchPage passando in get il valore nella txt
            function cercaProdotto(txt)
            {
                document.getElementById("formSearch").action = "/Amazoff/Ser                            vletFindProduct?p=" + document.getElementById(txt).value
                //window.location = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value;
            }
                                    
            // gestione POPOVER button notifiche
            /* prova ok $(document).ready(function(){
                $('[data-toggle="popover"]').attr('data-content', '<a href=\"\">HTML</a><b>Aggiunto</b> da <i>funzione</i>.');
                $('[data-toggle="popover"]').popover();
            }); */
        </script>
    </body>
</html>
