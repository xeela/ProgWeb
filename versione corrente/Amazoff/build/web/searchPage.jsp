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

        <!--Se lo lascio non va il POPOVER per le notifiche
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>-->
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        <script type="text/javascript" src="js/json_sort.js"></script>

        <link rel="stylesheet" href="css/amazoffStyle.css" />
        <script type="text/javascript">
            var productSearched = "${searchedProduct}";
            var jsonProdotti = ${jsonProdotti};
            var jsonNotifiche = ${jsonNotifiche}; // da errore se l'utente non è loggato, perche non ha delle notifiche associate
            

        </script>
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle">

        <div class="container-fluid tmargin">

            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>

            <!-- Corpo della pagina -->
            <div class="col-xs-12 col-lg-10">
                <div>
                    <!-- row contenente il menu / searchbar e button vari -->
                    <div class="row" > 
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
                                                if (userType.equals("1") || userType.equals("2")) {
                                        %>
                                        <a href="notificationPage.jsp">
                                            <span class="badge iconSize imgCenter" id="totNotifichexs"> 
                                                <spam class="glyphicon glyphicon-inbox"></spam>

                                            </span>
                                        </a>

                                        <%
                                                }
                                            } catch (Exception ex) {
                                            }
                                        %> 
                                    </div>                    

                                    <div class="col-xs-3 hidden-lg iconSize imgCenter" >
                                        <a href="shopping-cartPage.jsp">
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
                                        <!-- <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                            <span class="glyphicon glyphicon-filter"></span>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-left hidden-xs"> 
                                          <li><a href="#">Vicinanza</a></li>
                                          <li><a href="#">Prezzo</a></li>
                                          <li><a href="#">Recensione</a></li>
                                        </ul> -->

                                        <div role="tablist" aria-multiselectable="true">
                                            <a type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="collapse" data-parent="#accordion"
                                               href="#collapseFilter" aria-expanded="false "  aria-haspopup="true"
                                               aria-controls="collapseFilter" >
                                                <span class="glyphicon glyphicon-filter"></span>
                                            </a>
                                        </div>
                                    </div>

                                    <input id="txtCerca" name="txtCerca" type="text" class="form-control" aria-label="..." placeholder="Cosa vuoi cercare?">

                                    <div class="input-group-btn">
                                        <!--<select class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false" id="search_category">Select category<span class="caret"></span></button>
                                            <option value="product">Product</option>
                                            <option value="seller">Seller</option>
                                        </select>-->
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
                                                if(userType.equals("0")) // registrato
                                                        {
                                                            %>
                                                            <li><a href="userPage.jsp?v=Profilo#profilo">Profilo</a></li>
                                                            <li><a href="userPage.jsp">Rimborso / Anomalia</a></li>
                                                            <li><a href="userPage.jsp?v=CreateShop#createshop">Diventa venditore</a></li>
                                                            <li role="separator" class="divider"></li>
                                                            <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                            <%
                                                        }
                                                        else if(userType.equals("1")) // venditore
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
                                                        }
                                                        else if(userType.equals("2")) //admin
                                                        {
                                                            %>
                                                            <li><a href="userPage.jsp?v=Profilo#profilo">Profilo</a></li>
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
                                        if (userType.equals("1") || userType.equals("2")) {
                                %>
                                <div class="col-lg-3">                                                    
                                    <button class="btn" title="Notifiche" data-container="body" data-toggle="popover" data-html="true" data-placement="bottom" data-content="">
                                        <span class="badge" id="totNotifiche"><span class="glyphicon glyphicon-inbox" aria-hidden="true"></span> </span>
                                    </button>   
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
                                                    <input class="form-control" type="number" placeholder="KM Max" name="distanzaMax"> 
                                                </p>
                                            </li>
                                            <li>Prezzo 
                                                <p>
                                                    <input class="form-control" type="number" placeholder="Da..." name="prezzoDa"> 
                                                    <input class="form-control" type="number" placeholder="A..." name="prezzoA">
                                                </p>
                                            </li>
                                            <li>Recensione
                                                <p>
                                                    <input type="radio" value="5stelle" name="filtro"> 5 stelle 
                                                    <input type="radio" value="4stelle" name="filtro"> 4 stelle 
                                                    <input type="radio" value="3stelle" name="filtro"> 3 stelle 
                                                    <input type="radio" value="2stelle" name="filtro"> 2 stelle 
                                                    <input type="radio" value="1stella" name="filtro"> 1 stella 
                                                </p>
                                            </li>
                                        </ul>
                                    </div>
                                    <div class="col-sm-6 col-lg-6">
                                        <h3 class="alignCenter">Categorie</h3>
                                        <hr>
                                        <ul class="no_dots"> 
                                            <li><input type="radio" value="product" name="categoria" checked="checked"> Oggetto</li>
                                            <li><input type="radio" value="seller" name="categoria"> Venditore</li>
                                            <li><input type="radio" value="category" name="categoria"> Categoria</li>
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
                                                            <input class="form-control" type="number" placeholder="KM Max" name="distanzaMax"> 
                                                        </p>
                                                    </li>
                                                    <li>Prezzo 
                                                        <p>
                                                            <input class="form-control"type="number" placeholder="Da..." name="prezzoDa"> 
                                                            <input class="form-control" type="number" placeholder="A..." name="prezzoA">
                                                        </p>
                                                    </li>
                                                    <li>Recensione
                                                        <p>
                                                            <input type="radio" value="5stelle" name="filtro"> 5 stelle 
                                                            <input type="radio" value="4stelle" name="filtro"> 4 stelle 
                                                            <input type="radio" value="3stelle" name="filtro"> 3 stelle 
                                                            <input type="radio" value="2stelle" name="filtro"> 2 stelle 
                                                            <input type="radio" value="1stella" name="filtro"> 1 stella 
                                                        </p>
                                                    </li>
                                                </ul>
                                            </div>
                                            <div class="navbar-header col-xs-6">
                                                <a class="btn navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                                    Scegli categoria <span class="caret"></span>
                                                </a>
                                                <ul class="dropdown-menu dropdown-menu-left col-xs-8 hidden-sm hidden-md hidden-lg"> <!-- ?????????? sull'ipad non sparisce -->
                                                    <li><a href="#"><input type="radio" value="product" name="categoria_xs" checked="checked"> Oggetto</a></li>
                                                    <li><a href="#"><input type="radio" value="seller" name="categoria_xs"> Venditore</a></li>
                                                    <li><a href="#"><input type="radio" value="category" name="categoria_xs"> Categoria</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </nav>
                            </div>
                        </div>
                    </div>

                    <!-- barra verticale a sx contentente i metodi di ordinamento-->
                    <div class="tmargin hidden-xs col-sm-2 col-lg-2">
                        <table class="table table-hover">
                            <tbody id="sorting">
                                <tr><th>Ordina per:</th></tr>
                                <tr><td id="price_asc"><a href="#">Costo: crescente</a></td></tr>
                                <tr><td id="price_desc"><a href="#">Costo: decrescente</a></td></tr>
                                <tr><td id="review_desc"><a href="#">Recensione: crescente</a></td></tr>
                                <tr><td id="review_desc"><a href="#">Recensione: decrescente</a></td></tr>
                            </tbody>
                        </table>
                    </div>

                    <!-- corpo della pagina contenente i risultati della ricerca -->
                    <div class="tmargin col-xs-12 col-sm-10">
                        <div id="zonaProdotti">
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
                    </div> 


                    <!-- back to top button -->
                    <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                    
                    <div class="col-xs-12 col-lg-12">
                        <!-- footer TODO -->
                        <footer style="background-color: red">
                            <p>&copy; Company 2017</p>
                        </footer> 
                    </div>

                </div>
            </div>
            
                            

            <!-- barra bianca a dx -->
            <div class="hidden-xs col-lg-1"></div>
        </div>



    <script>
        LogJson();
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
            $('[data-toggle="popover"]').attr('data-content', inserisciNotifiche());
            $('[data-toggle="popover"]').popover({
                container: 'body'
            });
        });

    </script>
</body>
</html>
