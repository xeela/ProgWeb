<%-- 
    Document   : productPage
    Created on : 19-set-2017, 10.56.58
    Author     : Davide Farina
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
        <!--<script type="text/javascript" src="js/jquery-1.9.1.min.js"></script> rompe il carousel-->
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script> 
        <script type="text/javascript" src="js/parametri-ricerca.js"></script>

        <link rel="stylesheet" href="css/amazoffStyle.css" />
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />

        <script>
            var quantita = 1;
            var jsonProdotto;
            var jsonNotifiche = ${jsonNotifiche};
            console.log(jsonNotifiche);

            function LogJson() {
                jsonProdotto = ${jsonProdotti};
                var url_string = window.location.href;
                var url = new URL(url_string);
                var id = url.searchParams.get("id");

                if (jsonProdotto == {} || jsonProdotto.result[0].id != id)
                    window.location.replace("/Amazoff/ServletPopulateProductPage?id=" + id);
                else
                {
                    PopulateData();
                    PopolaReviews();
                    PopolaCarousel();
                    Autocomplete("product");
                }
            }

            function PopolaReviews() {
                var toAdd = "";

                if (!(jsonProdotto.result[0].reviews.length > 0))
                {
                    toAdd += "<h4>Nessuna recensione presente</h4>";
                } else
                {

                    for (var i = 0; i < jsonProdotto.result[0].reviews.length; i++)
                    {
                        toAdd += "<div class=\"row panel panel-default\"> ";
                        toAdd += "         <div class=\"col-lg-12\">";
                        // Cambiare il tipo di stella in base al numero di stelle tot (global value)
                        toAdd += "             <div class=\"col-xs-12 col-sm-2\" >";
                        /** Cambiare il tipo di stella in base al numero di stelle tot (global value) */
                        toAdd += insertStartsInReview(jsonProdotto.result[0].reviews[i].global_value);
                        toAdd += "             </div>";
                        toAdd += "             <div class=\"col-xs-12 col-sm-10\" >"
                        toAdd += "                  <p><b>" + jsonProdotto.result[0].reviews[i].name + ":</b> " + jsonProdotto.result[0].reviews[i].description + "</p>";
                        toAdd += "             </div>";
                        toAdd += "         </div>";
                        toAdd += "</div>";
                    }
                }

                $("#div_reviews").html(toAdd);
            }

            function insertStartsInReview(stelle)
            {
                var toAdd = "";

                for (var i = 1; i <= Math.round(stelle); i++)
                {
                    toAdd += "<span class=\"glyphicon glyphicon-star\"></span>";
                }
                for (var i = Math.round(stelle); i < 5; i++)
                {
                    toAdd += "<span class=\"glyphicon glyphicon-star-empty\"></span>";
                }
                return toAdd;
            }

            function PopulateData()
            {
                var toAdd = "";
                var id_product = jsonProdotto.result[0].id;

                toAdd += "<h3 name=\"nome\">" + jsonProdotto.result[0].name + "</h3>";
                toAdd += "<p name=\"stelle\">Valutazione: " + jsonProdotto.result[0].global_value_avg + "</p>";
                toAdd += "<p name=\"recensioni\" >Tot recensioni: " + jsonProdotto.result[0].num_reviews + "</p>";
                toAdd += "<p name=\"linkmappa\" ><a href='ServletShowShopOnMap?id=" + jsonProdotto.result[0].id_shop + "'>Vedi negozio su mappa</a></p>";
                toAdd += "<p name=\"venditore\" >Venditore: " + jsonProdotto.result[0].first_name + " " + jsonProdotto.result[0].last_name + "</p> <a href=\"" + jsonProdotto.result[0].web_site + "\">Sito web " + jsonProdotto.result[0].shop + "</a><p> Negozio id:" + jsonProdotto.result[0].id_shop + "</a></p>";
                toAdd += "<h4 name=\"prezzo\">Prezzo: " + jsonProdotto.result[0].price + " €</h4>";
                // buttons + , - , remove
                toAdd += " <div class=\"row col-xs-12 col-sm-6\" >";
                toAdd += "    <div>";
                toAdd += "         <button class=\"btn btn-primary col-lg-3\" onclick=\"aggiungi(" + id_product + ", " + quantita + ")\"><span class=\"glyphicon glyphicon-plus\"></span></button>";
                toAdd += "         <p class=\"btn col-lg-3\" id=\"quantita" + id_product + "\">" + quantita + "</p>";
                toAdd += "         <button class=\"btn btn-danger col-lg-3\" onclick=\"rimuovi(" + id_product + "," + quantita + ")\"><span class=\"glyphicon glyphicon-minus\"></span></button>";
                toAdd += "     </div>";
                toAdd += "</div>";

                toAdd += "<a href=\"/Amazoff/ServletAddToCart?productID=" + jsonProdotto.result[0].id + "&requested=" + quantita + "\" class=\"btn btn-warning\"><span class=\"glyphicon glyphicon-shopping-cart\"></span> Aggiungi al carrello</a></div>";

                $("#div_dati").html(toAdd);
            }

            function aggiungi(id_prod, amount)
            {
                quantita++;
                PopulateData();
            }

            function rimuovi(id_prod, amount)
            {
                if (quantita > 1)
                    quantita--;
                PopulateData();
            }

            function PopolaCarousel() {
                var toAdd = "";
                
                if(!(jsonProdotto.result[0].pictures.length > 0 || jsonProdotto.result[0].pictures[0].path == undefined))
                    toAdd = "<img class=\"imgResize\" src=\"UploadedImages/default.jpg\" alt=\"Immagine non trovata\">";
                else
                    toAdd = "<img class=\"imgResize\" src=\"UploadedImages/" + jsonProdotto.result[0].pictures[0].path + "\" onerror=\"this.src='UploadedImages/default.jpg'\">";
                
                $("#div_productImage").html(toAdd);
            }
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
                                            <script>document.getElementById("iconAccediRegistrati").href = "loginPage.jsp";</script>

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
                                            if (userType.equals("0") ||userType.equals("1") || userType.equals("2")) {
                                    %>
                                    <a href="notificationPage.jsp">
                                    <a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche">
                                        <span class="badge iconSize imgCenter" id="totNotifichexs"> 
                                            <spam class="glyphicon glyphicon-inbox"></spam> 
                                             <i class="fa fa-spinner fa-spin" ></i> 
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
                                </div>
                            </form>
                        </div>
                    </div>                     

                    <!-- button: accedi/registrati e carrello per PC -->
                    <div class="hidden-xs hidden-sm hidden-md col-lg-4">

                        <div class="row">                                
                            <div class="dropdownUtente col-lg-7" >
                                <div class="btn-group">
                                    <a href="userPage.jsp" class="btn btn-default maxlength dotsEndSentence" type="button" id="btnAccediRegistrati" >
                                        <%
                                            userType = "";
                                            String fname = "", lname = "";
                                            try {
                                                String user = (session.getAttribute("user")).toString();
                                                userType = (session.getAttribute("categoria_user")).toString();
                                                fname = (session.getAttribute("fname")).toString();
                                                lname = (session.getAttribute("lname")).toString();
                                        %>
                                        <%= fname + " " + lname%>
                                        <%
                                        } catch (Exception ex) {
                                        %>
                                        Accedi / Registrati

                                        <script>document.getElementById("btnAccediRegistrati").href = "loginPage.jsp";</script>
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
                                        <li><a href="userPage.jsp?v=Profile#profilo">Profilo</a></li>
                                        <li><a href="ServletMyOrders">Miei ordini</a></li>
                                        <li><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche">Notifiche</a></li>
                                        <li><a href="userPage.jsp">Rimborso / Anomalia</a></li>
                                        <li><a href="userPage.jsp?v=CreateShop#createshop">Diventa venditore</a></li>
                                        <li role="separator" class="divider"></li>
                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                            <%
                                        }
                                        else if(userType.equals("1")) // venditore
                                        {
                                            %>
                                        <li><a href="userPage.jsp?v=Profile#profilo">Profilo</a></li>
                                        <li><a href="ServletMyOrders">Miei ordini</a></li>
                                        <li><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche">Notifiche</a></li>
                                        <li><a href="userPage.jsp">Negozio</a></li>
                                        <li><a href="userPage.jsp?v=SellNewProduct#sellNewProduct">Vendi Prodotto</a></li>
                                        <!--<li><a href="userPage.jsp?v=GestisciProdotti#gestisciProdotti">Gestisci prodotti</a></li>-->
                                        <li role="separator" class="divider"></li>
                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                            <%
                                        }
                                        else if(userType.equals("2")) //admin
                                        {
                                            %>
                                        <li><a href="userPage.jsp?v=Profile#profilo">Profilo</a></li>
                                        <li><a href="ServletMyOrders">Miei ordini</a></li>
                                        <li><a href="ServletRecuperaAnomalie">Gestione anomalie</a></li>
                                        <li><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche">Notifiche</a></li>
                                        <li role="separator" class="divider"></li>
                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                            <%
                                        }
                                        else { %>
                                        <li><a href="loginPage.jsp">Accedi</a></li>
                                        <li><a href="loginPage.jsp">Registrati</a></li>
                                            <%  } %>

                                    </ul>  
                                </div>
                            </div>

                            <!-- nel caso in cui l'utente sia venditore o admin, visualizzo il btn NOTIFICHE -->
                            <% try {
                                //userType = (session.getAttribute("categoria_user")).toString();
                                if (userType.equals("0") || userType.equals("1") || userType.equals("2")) {
                            %>
                            <div class="col-lg-3">                                                    
                                <button class="btn" title="Notifiche" data-container="body" data-toggle="popover" data-html="true" data-placement="bottom" data-content="">
                                    <span class="badge" id="totNotifiche"><span class="glyphicon glyphicon-inbox" aria-hidden="true"></span> </span>
                                </button>   
                            </div> 
                            <%
                                    }
                                } 
                                catch (Exception ex) { }
                            %> 

                            <div class="col-lg-2">
                                <a href="ServletShowCart" type="button" class="btn btn-default btn-md">
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

                <!-- corpo della pagina contenente i dati dell'oggetto selezionato -->
                <div class="tmargin col-xs-12">
                    <!-- div contenente i dati relativi al prodotto -->
                    <div class="row panel panel-default">                          

                        <!-- Slider -->
                        <div class="col-xs-12 col-md-6 col-lg-6">
                            <div class="row">
                                <div id="slider">
                                    <!-- Top part of the slider -->
                                    <div class="row">
                                        <div class="col-lg-12" id="carousel-bounding-box">
                                            <div class="carousel slide" id="myCarousel">
                                                <!-- Carousel items -->
                                                <div class="carousel-inner" id="div_productImage">

                                                </div>                     
                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div><!--/Slider-->
                        </div>
                        
                        <!-- dettagli prodotto -->
                        <div class="col-xs-12 col-md-5 col-lg-6" id="div_dati">

                        </div>
                    </div>

                    <!-- RECENSIONI -->
                    <h3>Recensioni: </h3>
                    <div id="div_reviews">

                        
                    </div>                  
                </div>

                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer -->
                <footer class="col-xs-12">
                    <div class="">
                        <div class="row" style="background-color: #dddddd">
                            <div class="col-xs-8 col-sm-4"><h5><b>Pagine</b></h5>
                                <p><a href="index.jsp"><span class="glyphicon glyphicon-menu-right"></span> Home</a></p>
                                <p><a href="searchPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Cerca prodotto</a></p> 
                                <p><a href="....."><span class="glyphicon glyphicon-menu-right"></span> Carrello</a></p> 
                                <!-- UTENTE SE "REGISTRATO" -> porta alla pag. ALTRIM. passa per la login -->
                                <%
                                    if(userType.equals("0")) // registrato
                                    {
                                %>
                                <p><a href="userPage.jsp?v=Profile#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                                <p><a href="ServletMyOrders"><span class="glyphicon glyphicon-menu-right"></span> Miei ordini</a></p>
                                <p><a href="userPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Rimborso / Anomalia</a></p>
                                <p><a href="userPage.jsp?v=CreateShop#createshop"><span class="glyphicon glyphicon-menu-right"></span> Diventa venditore</a></p>
                                <!-- NON SO SE SERVE. In teoria si. SE si va aggiunto anche nei menu a tendina -->
                                <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>

                                <%  }
                                    else if(userType.equals("1")) // venditore
                                    {  %>
                                <!-- UTENTE SE "VENDITORE" -> porta alla pag. ALTRIM. passa per la login -->
                                <p><a href="userPage.jsp?v=Profile#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                                <p><a href="ServletMyOrders"><span class="glyphicon glyphicon-menu-right"></span> Miei ordini</a></p>
                                <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>
                                <p><a href="userPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Negozio</a></p>
                                <p><a href="userPage.jsp?v=SellNewProduct#sellNewProduct"><span class="glyphicon glyphicon-menu-right"></span> Vendi Prodotto</a></p>
                                <p><a href="userPage.jsp?v=GestisciProdotti#gestisciProdotti"><span class="glyphicon glyphicon-menu-right"></span> Gestisci prodotti</a></p>
                                <%  }
                                    else if(userType.equals("2")) // admin
                                    {  %> 
                                <p><a href="userPage.jsp?v=Profile#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                                <p><a href="ServletMyOrders"><span class="glyphicon glyphicon-menu-right"></span> Miei ordini</a></p>
                                <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>
                                <%  }
                                    else // non loggato
                                    {  %>    
                                <p><a href="loginPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Accedi</a></p>
                                <p><a href="loginPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Registrati</a></p>
                                <%  }  %>        
                            </div>
                            <div class="hidden-xs col-sm-4"><h5><b>Categorie</b></h5>
                                <p><a href="index.jsp"><span class="glyphicon glyphicon-menu-right"></span> Oggetto</a></p>
                                <p><a href="searchPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Venditore</a></p>
                            </div>

                            <div class="col-xs-4"><h5><b>Logout</b></h5>
                                <p><a href="ServletLogout"><span class="glyphicon glyphicon-menu-right"></span> ESCI</a></p>
                            </div>
                        </div>
                        <p>&copy; Amazoff 2017 - info@amazoff.com - via di Amazoff 69, Trento, Italia</p>
                    </div>
                </footer>
            </div>
            <!-- barra bianca a dx -->
            <div class="hidden-xs col-lg-1"></div>
        </div>



        <script>
            // When the user scrolls down 20px from the top of the document, show the button
            window.onscroll = function () {
                scrollFunction()
            };

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

            // crea l'html per il button delle notifiche
            function inserisciNotifiche()
            {
                console.log(jsonNotifiche);
                var toAdd = "<div style=\"height: 300px; overflow-y:auto;\">";
                var notificationCount = 0;
                var notifiche = "";
                var idNotifica;
                for (var i = jsonNotifiche.notifications.length - 1; i >= 0; i--)
                {
                    idNotifica = jsonNotifiche.notifications[i].id;
                    toAdd += "<a href=\"" + jsonNotifiche.notifications[i].link + "&notificationId=" + idNotifica + "\">"; // userPage.jsp?v=Notifiche&i="+idNotifica+"#notifica" + idNotifica + "
                    toAdd += "<p>";
                    switch (jsonNotifiche.notifications[i].type)
                    {
                        case "0":
                            toAdd += "<span class=\"glyphicon glyphicon-user\"></span>";
                            break;
                        case "1":
                            toAdd += "<span class=\"glyphicon glyphicon-envelope\"></span>";
                            break;
                        default:
                            break;
                    }

                    if (jsonNotifiche.notifications[i].already_read === "0") {
                        //toAdd += "<p style=\"color: red\">";
                        notificationCount++;
                        toAdd += " <b style=\"color: red\">NEW!</b> </p>";
                        toAdd += "<div class=\"dotsEndSentence\"><b>" + jsonNotifiche.notifications[i].description + "</b></div>";
                    } else {
                        toAdd += "</p>";
                        toAdd += "<div class=\"dotsEndSentence\">" + jsonNotifiche.notifications[i].description + "</div>";

                    }

                    // ---> toAdd += "<div>"+ jsonNotifiche.notifications[i].date_added +"</div>";
                    toAdd += "</a><hr>";

                }
                toAdd += "</div>";
                toAdd += "<div><a href=\"userPage.jsp?v=Notifiche&notificationId=tutte#notifiche\">Vedi tutte</a></div>";

                if (notificationCount > 99)
                    notificationCount = "99+";
                $("#totNotifichexs").html("<span class=\"glyphicon glyphicon-inbox\"></span> " + notificationCount);
                $("#totNotifiche").html("<span class=\"glyphicon glyphicon-inbox\"></span> " + notificationCount);

                return toAdd;
            }

            // gestione POPOVER button notifiche
            $(document).ready(function () {
                $('[data-toggle="popover"]').popover({
                    container: 'body'
                });
            });

            // inizializzazione delle notifiche e del suo button.
            $('[data-toggle="popover"]').attr('data-content', inserisciNotifiche());

        </script>
    </body>
</html>
</html>