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
        
        <link rel="stylesheet" href="css/amazoffStyle.css" />
        
        <script type="text/javascript">
        <!--    var jsonProdotti;
            function LogJson() {
                jsonProdotti = ${jsonProdotti};
                console.log(jsonProdotti);
                AggiungiProdotti();
            }
            
            function AggiungiProdotti() {
                var toAdd = "";
                for(var i = 0; i < jsonProdotti.products.length; i++)
                {
                    toAdd += "<div class=\"row panel panel-default\">";
                    toAdd += "<a href=\"productPage.jsp?id=id_oggetto\" id=\"id_oggetto\">";
                    toAdd += "<div class=\"col-xs-4 col-sm-3 col-md-2\"  style=\"background-color: green; margin: 0 0 0 0;\">";
                    toAdd += "immagine";
                    toAdd += "</div>";
                    toAdd += "<div class=\"col-xs-8 col-sm-7 col-md-9\">";
                    toAdd += "<p id=\"nome+\" >" + jsonProdotti.products[i].name + "</p>";
                    toAdd += "<p id=\"stelle+\">Voto totale</p>";
                    toAdd += "<p id=\"recensioni+\" >#num recensioni</p>";
                    toAdd += "<p id=\"linkmappa\" >Vedi su mappa</p>";
                    toAdd += "<p id=\"prezzo+\">Prezzo: " + jsonProdotti.products[i].price + "</p>";
                    toAdd += "<p id=\"venditore+\" >Nome venditore <a href=\"url_venditore.html\">Negozio</a></p>";       

                    toAdd += "</div>";
                    toAdd += "<div class=\"hidden-xs col-sm-2 col-md-1\" >";
                    toAdd += "<span class=\"prova glyphicon glyphicon-chevron-right\"></span>";
                    toAdd += "</div>";
                    toAdd += "</a>";
                    toAdd += "</div>";
                }
                
                $("#zonaProdotti").html(toAdd);
            }
            
            // dato un elemento text input, reindirizza alla pagina searchPage passando in get il valore nella txt
            function cercaProdotto(txt)
            {
                window.location = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value;
            } -->
            
       
            
        </script> 
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle" onload="LogJson()">
            
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
                                <div class="col-xs-2 hidden-lg" style="text-align: right"><a href="shopping-cartPage.jsp"> <spam class="glyphicon glyphicon-shopping-cart"></spam></a></div>
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
                                  <button class="btn btn-default" type="button" onclick="cercaProdotto('txtCerca')">Cerca</button>
                                </div><!-- /btn-group --> 
                            </div><!-- /input-group -->
                        </div>                     
                        
                        <!-- button: accedi/registrati e carrello per PC -->
                        <div class="hidden-xs hidden-sm hidden-md col-lg-4">
                        
                            <div class="row">                                
                                <div class="dropdownUtente col-lg-7" >
                                    <div class="btn-group">
                                        <a href="paginaUtenteDaCreare.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
                                            <% 
                                                String userType = "";
                                                try {
                                                    String user = (session.getAttribute("user")).toString();
                                                    userType = (session.getAttribute("categoria_user")).toString();
                                            %>
                                            <%= user %>
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
                                                        <li><a href="userPage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Rimborso / Anomalia</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("1")) // venditore
                                                    {
                                                        %>
                                                        <li><a href="userPage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Notifiche</a></li>
                                                        <li><a href=".jsp">Negozio</a></li>
                                                        <li><a href=".jsp">Gestisci prodotti</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("2")) //admin
                                                    {
                                                        %>
                                                        <li><a href="userPage.jsp">Profilo</a></li>
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
                                
                                <div class="col-lg-4">
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
                 
               <!-- corpo della pagina contenente i dati dell'oggetto selezionato -->
               <div class="tmargin col-xs-12 col-sm-10">
                   <!-- div contenente i dati relativi al prodotto -->
                   <div class="row panel panel-default">         
                        <!-- <div class="col-xs-12 col-md-5 col-lg-5">
                            <p class="col-xs-12" style="background-color: aqua" >Immagine principale</p>
                            <p class="col-xs-4" style="background-color: red" >img 2</p> 
                            <p class="col-xs-4" style="background-color: green" >img 3</p> 
                            <p class="col-xs-4" style="background-color: yellow" >img 4</p> <!-- quando vengono cliccate venono sostituite con l'img principale -->
                        <!--</div> -->
                        
                        
                        
                        
                        <!-- Slider -->
                        <div class="col-xs-12 col-md-6 col-lg-6">
                            <div class="row">
                                <div id="slider">
                                    <!-- Top part of the slider -->
                                    <div class="row">
                                        <div class="col-lg-12" id="carousel-bounding-box">
                                            <div class="carousel slide" id="myCarousel">
                                                <!-- Carousel items -->
                                                <div class="carousel-inner">
                                                    <div class="active item" data-slide-number="0">
                                                    <img src="http://placehold.it/770x300&text=one"></div>

                                                    <div class="item" data-slide-number="1">
                                                    <img src="http://placehold.it/770x300&text=two"></div>

                                                    <div class="item" data-slide-number="2">
                                                    <img src="images/img3.jpg"></div>

                                                </div><!-- Carousel nav -->
                                                <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                                                    <span class="glyphicon glyphicon-chevron-left"></span>                                       
                                                </a>
                                                <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                                                    <span class="glyphicon glyphicon-chevron-right"></span>                                       
                                                </a>                                
                                                </div>
                                        </div>


                                    </div>
                                </div>
                            </div><!--/Slider-->

                            
                            <!-- BARRA CONTENENTE LE miniature delle img del prodotto-->
                            <div class="row tmargin">
                                <div class="hidden-xs hidden-sm" id="slider-thumbs">
                                    <!-- Bottom switcher of slider -->
                                    <div style="list-style:none;" >
                                            <div class="col-md-4">
                                                <a class="thumbnail" id="carousel-selector-0"><img src="http://placehold.it/170x100&text=one"></a>
                                            </div>

                                            <div class="col-md-4">
                                                <a class="thumbnail" id="carousel-selector-1"><img src="http://placehold.it/170x100&text=two"></a>
                                            </div>

                                            <div class="col-md-4">
                                                <a class="thumbnail" id="carousel-selector-2"><img src="images/img3.jpg"></a>
                                            </div>


                                    </div>                 
                                </div>
                            </div>
                        </div>                       
                        
                        <div class="col-xs-12 col-md-5 col-lg-6">
                            <p id="nome+" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->
                            <p id="stelle+">Voto totale</p>
                            <p id="recensioni+" >#num recensioni</p>
                            <p id="linkmappa" >Vedi su mappa</p>
                            <p id="prezzo+">Prezzo</p>
                            <p id="venditore+" >Nome venditore <a href="url_venditore.html">Negozio</a></p>                                
                            <button class="btn btn-warning"><span class="glyphicon glyphicon-shopping-cart"></span> Aggiungi al carrello</button>
                        </div>
                   </div>
                   
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
                          
                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer -- ROMPE TUTTO --
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
            
                  $('#myCarousel').carousel({
                interval: 5000
        });
 
        <!-- CODICE per la gestione del CAROUSEL delle immagini -->
           //Handles the carousel thumbnails
           $('[id^=carousel-selector-]').click( function(){
                var id = this.id.substr(this.id.lastIndexOf("-") + 1);
                var id = parseInt(id);
                $('#myCarousel').carousel(id);
            });
        // FINE carousel
        
        </script>
    </body>
</html>
