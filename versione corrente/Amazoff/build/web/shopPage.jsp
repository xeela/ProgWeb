<%-- 
    Document   : shopPage
    Created on : 6-gen-2018, 17.66.22
    Author     : Gianluca Pasqua
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
            var jsonNegozio;
            var jsonNotifiche = ${jsonNotifiche};
            console.log(jsonNotifiche);

            function LogJson() {
                jsonNegozio = ${jsonNegozio};
                console.log(jsonNegozio);


                PopulateData();
                PopolaReviews();
                PopolaCarousel();
                Autocomplete("product");
            }

            function PopolaReviews() {
                var toAdd = "";
                /*
                 if(!(jsonNegozio.result[0].reviews.length > 0)) 
                 {
                 toAdd += "<h4>Nessuna recensione presente</h4>";
                 }
                 else 
                 {
                 
                 for (var i = 0; i < jsonNegozio.result[0].reviews.length; i++)
                 {
                 */
                toAdd += "<div class=\"row panel panel-default\"> ";
                toAdd += "         <div class=\"col-lg-12\">";
                /*     toAdd += "             <div class=\"col-xs-12 col-lg-2\" style=\"background-color: aqua\" >";
                 // Cambiare il tipo di stella in base al numero di stelle tot (global value)
                 toAdd += insertStartsInReview(jsonNegozio.result[0].reviews[i].global_value);
                 toAdd += "             </div>";
                 toAdd += "             <p><b>"+ jsonNegozio.result[0].reviews[i].name +":</b> " + jsonNegozio.result[0].reviews[i].description + "</p>";
                 */    toAdd += "         </div>";
                toAdd += "</div>"; /*
                 }
                 }
                 */
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
                var id_shop = jsonNegozio.result[0].id;

                toAdd += "<h3 name=\"nome\">" + jsonNegozio.result[0].name + "</h3>";
                toAdd += "<p name=\"stelle\">Valutazione: " + jsonNegozio.result[0].value + "</p>";
                //toAdd += "<p name=\"recensioni\" >Tot recensioni: "+ jsonNegozio.result[0].num_reviews +"</p>";
                toAdd += "<p name=\"linkmappa\" ><a href='ServletShowShopOnMap?id=" + jsonNegozio.result[0].id + "'>Vedi negozio su mappa</a></p>";
                //toAdd += "<p name=\"venditore\" >Venditore: "+ jsonNegozio.result[0].first_name +" " + jsonNegozio.result[0].last_name;
                toAdd += "</p> <a href=\"" + jsonNegozio.result[0].web_site + "\">Sito web " + jsonNegozio.result[0].name + "</a><p> Negozio id: " + jsonNegozio.result[0].id + "</a></p>";
                toAdd += "<p name=\"apertura\">Giorni di apertura: " + +"</p>";
                $("#div_dati").html(toAdd);
            }


            function PopolaCarousel() {
                /*    var toAdd = "", toAddMiniature = "";
                 
                 for (var i = 0; i < jsonNegozio.result[0].pictures.length; i++)
                 {
                 if (i == 0)
                 toAdd += "<div class=\"active item\" data-slide-number=\"0\">";
                 else
                 toAdd += "<div class=\"item\" data-slide-number=\"" + i + "\">";
                 
                 toAdd += "<img class=\"imgResize imgCenter\" src=\"UploadedImages/" + jsonProdotto.result[0].pictures[i].path + "\"></div>";
                 }
                 
                 $("#div_carousel").html(toAdd);
                 */
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
                            <div class="col-xs-6 col-lg-12"><a href="index.jsp">
                                    <img src="images/logo/logo.png" class="logo2" alt="Amazoff"/>
                                </a></div>
                            <div class="col-xs-2 hidden-lg" style="text-align: right"> 
                                <a style="none" class="dropdown" href="userPage.jsp" id="iconAccediRegistrati"><spam class="glyphicon glyphicon-user"></spam></a>
                                        <%
                                            try {
                                                String user = (session.getAttribute("user")).toString();

                                            } catch (Exception ex) {
                                        %>
                                <script>document.getElementById("iconAccediRegistrati").href = "loginPage.jsp";</script>
                                <%
                                    }
                                %>


                            </div>

                            <!-- nel caso in cui l'utente sia venditore o admin, visualizzo il btn NOTIFICHE -->
                            <%
                                String userType = "";
                                try {
                                    userType = (session.getAttribute("categoria_user")).toString();
                                    if (userType.equals("0") || userType.equals("1") || userType.equals("2")) {
                            %>
                            <div class="col-xs-2 hidden-lg" style="text-align: right;">
                                <span class="badge"><a href="notificationPage.jsp"> <spam class="glyphicon glyphicon-inbox"></spam> 11</a></span>
                            </div>
                            <%
                                    }
                                } catch (Exception ex) {
                                }
                            %> 
                            <div class="col-xs-2 hidden-lg" style="text-align: right"><a href="ServletAddToCart"> <spam class="glyphicon glyphicon-shopping-cart"></spam></a></div>
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
                                <input id="categoriaRicerca" name="categoriaRicerca" type="text" style="display:none;" value="product">

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

                <!-- corpo della pagina contenente i dati del negozio selezionato -->
                <div class="tmargin col-xs-12">
                    <!-- div contenente i dati relativi al negozio -->
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
                                                <div class="carousel-inner" id="div_carousel">

                                                </div>


                                            </div>
                                        </div>


                                    </div>
                                </div>
                            </div><!--/Slider-->
                        </div>                       

                        <div class="col-xs-12 col-md-5 col-lg-6" id="div_dati">
                            <p name="nome" ></p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del negozio-->
                            <p name="stelle">Voto totale</p>
                            <p name="recensioni" >#num recensioni</p>
                            <p name="linkmappa" >Vedi su mappa</p>
                            <p name="prezzo">Indirizzo</p>
                            <p name="venditore" >Nome venditore <a href="url_venditore.html">Negozio</a></p>  

                            <!--<div class="col-xs-12 col-sm-6" >
                                <div>
                                    <button class="btn btn-primary col-lg-3" onclick="aggiungi("+id_oggetto+", "+ cart.products[i].quantita + ","+i+")"><span class="glyphicon glyphicon-plus"></span></button>
                                    <p class="btn col-lg-3" id=\"quantita"+id_oggetto+">"+ cart.products[i].quantita + "</p>
                                    <button class="btn btn-danger col-lg-3" onclick="rimuovi("+id_oggetto+", "+ cart.products[i].quantita + ","+i+")"><span class="glyphicon glyphicon-minus"></span></button>
                                </div>
                            </div> -->
                        </div>
                    </div>

                    <h3>Recensioni: </h3>
                    <!-- RECENSIONI -->
                    <div id="div_reviews">

                        <!-- div contenente: recensione -->
                        <div class="row panel panel-default">         
                            <div class="col-lg-12">
                                <div style="background-color: aqua" >
                                    <span class="glyphicon glyphicon-star"></span>  
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span> 
                                </div>

                                <!-- div con testo espandibile, contenente la recensione -->
                                <div class="panel-group" role="tablist" aria-multiselectable="true">
                                    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut a purus at felis viverra congue. Duis quis cursus ligul
                                    <div id="collapseOne" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="headingOne">
                                        Nunc pretium lacus sed dui tincidunt, eu luctus nisl viverra. Donec pretium congue sapien, nec efficitur risus egestas ut. Nam condimentum massa dolor. Suspendisse luctus non leo vehicula sagittis. Etiam placerat enim non mauris sodales, ut euismod elit sodales. Phasellus commodo at tellus non interdum. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Quisque porttitor justo non lorem lacinia, non tempor tortor bibendum. Mauris viverra magna vitae cursus imperdiet. Aliquam vehicula mi felis, in varius elit consectetur eget. Morbi neque elit, blandit in varius vitae, suscipit in nunc. Ut interdum ante eu ornare ultricies. Nam maximus faucibus porta.In hac habitasse platea dictumst. In tempus massa nec ipsum fringilla, quis elementum tellus euismod. Morbi quis metus sit amet eros semper mattis vel a sapien. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Maecenas ullamcorper tincidunt sapien, eget maximus felis condimentum quis. Ut in semper nunc. Donec at magna lorem. Mauris dignissim justo vitae quam bibendum egestas.Vestibulum tellus neque, porttitor in placerat eget, posuere at mi. In eget tincidunt augue. Nulla elementum ornare urna. Donec id iaculis est, vel ultricies tortor. Curabitur sagittis tempus turpis in mattis. Donec ut tempus justo, vitae pharetra velit. Pellentesque ac luctus mi. Donec efficitur elementum leo, sed venenatis mauris facilisis sed. Fusce sed vulputate nunc, vitae egestas enim. Suspendisse rhoncus risus vitae ipsum hendrerit mollis. Proin ut justo justo. Cras lacinia lorem posuere laoreet finibus. Donec justo purus, consectetur lobortis volutpat vel, sodales venenatis ligula. Etiam eget interdum magna. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Praesent cursus, nunc quis cursus vulputate, magna libero scelerisque lacus, vel gravida arcu mauris vitae neque. Ut eu eleifend lorem, quis feugiat arcu. Nullam condimentum faucibus tortor, ut posuere velit pellentesque nec. Praesent finibus iaculis ultrices. Etiam dolor ante, posuere vitae ex et, finibus fermentum ante. Cras eu rutrum diam. Nullam sed rutrum risus, et iaculis risus. Aenean ut nisi sagittis nibh pulvinar rhoncus ac a nunc. Suspendisse et lorem in nunc sollicitudin egestas feugiat in mi. Nam ut tellus sodales, pellentesque mi et, faucibus arcu. Proin posuere, ipsum vel pretium porta, lorem lacus finibus risus, viverra iaculis lacus massa vitae velit. Vivamus at tincidunt metus, eu interdum metus. Phasellus dolor erat, varius eu mi vel, suscipit molestie sapien. Sed fringilla dui vitae elit commodo condimentum. Phasellus consectetur enim orci, eget mattis dolor hendrerit nec. Sed tincidunt cursus ipsum, rhoncus venenatis lacus. Mauris porttitor quam nunc, id ultricies nibh euismod quis. Nam pulvinar turpis sem, quis luctus nunc ullamcorper vitae. Vestibulum nunc diam, finibus id pretium a, placerat vitae ligula. Suspendisse tristique massa vel aliquet aliquam. Vivamus euismod diam id dui pellentesque pulvinar. Ut tincidunt varius libero sit amet aliquam. Aliquam at justo nec lorem mollis euismod sit amet id erat.
                                    </div> 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        <span class="glyphicon glyphicon-option-horizontal"></span>
                                    </a>
                                </div>                          

                            </div>
                        </div>

                        <div class="row panel panel-default">         
                            <div class="col-lg-12">
                                <div class="col-xs-12 col-lg-2" style="background-color: aqua" >
                                    <span class="glyphicon glyphicon-star"></span>  
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span> 
                                </div>
                                <p >recensione</p> <!-- quando vengono cliccate venono sostituite con l'img principale -->

                            </div>
                        </div>

                        <div class="row panel panel-default">         
                            <div class="col-lg-12">
                                <div class="col-xs-12 col-lg-2" style="background-color: aqua" >
                                    <span class="glyphicon glyphicon-star"></span>  
                                    <span class="glyphicon glyphicon-star"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                    <span class="glyphicon glyphicon-star-empty"></span> 
                                </div>
                                <p >recensione</p> <!-- quando vengono cliccate venono sostituite con l'img principale -->

                            </div>
                        </div>
                    </div>                    
                </div>

                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer -->
                <footer class="col-xs-12">
                    <div class="">
                        <div class="row" style="background-color: #fc5d5d">
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
