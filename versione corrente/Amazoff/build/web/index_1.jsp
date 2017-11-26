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
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        
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
            }
            
            function AggiungiProdotti() {
                var toAdd = "";
                var id_oggetto = -1
                
                for(var i = 0; i < jsonProdotti.products.length; i++)
                {
                    id_oggetto = jsonProdotti.products[i].id;
                    
                    toAdd += "<div class=\"col-sm-6 col-md-4\">";
                    toAdd += "<div class=\"thumbnail\">";
                    toAdd += "<img class=\"imgResize\" src=\"UploadedImages/"+ jsonProdotti.products[i].pictures[0].path + "\" alt=\"...\">";
                    toAdd += "<div class=\"caption\">";
                    toAdd += "<h3>" + jsonProdotti.products[i].name + "</h3>";
                    toAdd += "<h4>" + jsonProdotti.products[i].price + "€</h4>";
                    toAdd += "<p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"#\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>";
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
        </script>
            
    </head>
    <body class="bodyStyle" onload="LogJson()">
       
        <div class="container-fluid tmargin">
            
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
                        <!-- barra con: login/registrati, cerca, carrello -->
                        <div class="logo col-xs-12 col-lg-1">
                            <div class="row">
                                <div class="col-xs-6 col-lg-12"><a href="index.jsp">
                                        <img class="logo2" src="images/logo/logo.png" alt="Amazoff"/>
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
                                                    <span class="badge"><a href="notificationPage.jsp"> <spam class="glyphicon glyphicon-inbox"></spam> 11</span>
                                                 </div>
                                                <%
                                            }
                                        }catch(Exception ex){   }
                                %> 
                                <div class="col-xs-2 hidden-lg" style="text-align: right"><a href="shopping-cartPage.jsp"> <spam class="glyphicon glyphicon-shopping-cart"></spam></a></div>
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
                                                String user = "", fname = "", lname = "";
                                                try {
                                                    //user = (session.getAttribute("user")).toString();
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
                                                        <li><a href="createShop_1.jsp">Diventa venditore</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("1")) // venditore
                                                    {
                                                        %>
                                                        <li><a href="profilePage.jsp">Profilo</a></li>
                                                        <li><a href="notificationPage.jsp">Notifiche</a></li>
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
                                                        <li><a href="notificationPage.jsp">Notifiche</a></li>
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
                            
                        <div class="col-xs-12 hidden-sm hidden-md hidden-lg">
                            <div class="menuBar">
                                <nav class="navbar navbar-default">
                                    <div class="container">
                                        <div class="row">
                                      
                                            <div class="navbar-header col-xs-8">
                                                <p class="navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                                    Scegli categoria <span class="caret"></span>
                                                </p>
                                                <ul class="dropdown-menu dropdown-menu-left col-xs-8 hidden-sm hidden-md hidden-lg"> <!-- ?????????? sull'ipad non sparisce -->
                                                    <li><a href="#">Categoria</a></li>
                                                    <li><a href="#">Oggetto</a></li>
                                                    <li><a href="#">Venditore</a></li>
                                                </ul>
                                            </div>
                                            <div class="navbar-header col-xs-4">
                                                <p class="navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                                    Filtri <span class="caret"></span>
                                                </p>
                                                <ul class="dropdown-menu dropdown-menu-right col-xs-8 hidden-sm hidden-md hidden-lg"> <!-- ?????????? sull'ipad non sparisce -->
                                                    <li><a href="#">Vicinanza</a></li>
                                                    <li><a href="#">Prezzo</a></li>
                                                    <li><a href="#">Recensione</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </nav>
                            
                            </div>
                            
                        </div>
                </div>
                     
                <!-- carousel -->
                <div class="row galleria">
                    <div class="col-lg-12">
                    <div id="myCarousel" class="carousel slide" data-ride="carousel">
                        <!-- Indicators -->
                        <ol class="carousel-indicators">
                          <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                          <li data-target="#myCarousel" data-slide-to="1"></li>
                          <li data-target="#myCarousel" data-slide-to="2"></li>
                        </ol>

                        <!-- Wrapper for slides -->
                        <div class="carousel-inner" role="listbox" style="background-color: aqua">

                          <div class="item active">
                            <img src="images/trova_venditori.jpg" alt="Chania">
                            <!--<div class="carousel-caption">
                              <h3>Chania</h3>
                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>
                            </div>-->
                          </div>

                          <div class="item">
                            <img src="images/img2.jpg" alt="Chania">
                            <!--<div class="carousel-caption">
                              <h3>Chania</h3>
                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>
                            </div>-->
                          </div>
                            
                            <div class="item">
                            <img src="images/img3.jpg" alt="Chania">
                            <!--<div class="carousel-caption">
                              <h3>Chania</h3>
                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>
                            </div>-->
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
                <footer style="background-color: red">
                    <p>&copy; Company 2017</p>
                </footer>
            
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
            
            // dato un elemento text input, reindirizza alla pagina searchPage passando in get il valore nella txt
            function cercaProdotto(txt)
            {
                document.getElementById("formSearch").action = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value
                //window.location = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value;
            }
            
        </script>
    </body>
</html>
