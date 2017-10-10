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
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle">
       
        <div class="container-fluid tmargin">
            
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
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
                                               String userType = "";
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
                                        
                                    </div>
                                </div>
                                
                                <div class="col-lg-4">
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
         
                <!-- tabella di 2 righe, con 3 colonne, che mostrano 6 prodotti -->
                <div class='tmargin'>
                    <div class="page">
                          <ul class="list-group">
                               <%
                                    if(userType.equals("0")) // registrato
                                    { %>
                                        <!--<a href="profilePage.jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Profilo
                                        </a>-->
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
                                        <a href=".jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Rimborso / Anomalia
                                        </a>
                                        <a href=".jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Diventa venditore
                                        </a>
                                        <a href="/Amazoff/ServletLogout" class="list-group-item active">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Esci
                                        </a>
                                                       
                                        <%
                                    }
                                    else if(userType.equals("1")) // venditore
                                    { %>
                                        <a href="profilePage.jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Profilo
                                        </a>
                                        <a href=".jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Notifiche
                                        </a>
                                        <a href=".jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Negozio
                                        </a>
                                        <a href="sellNewProduct.jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Vendi prodotto
                                        </a>
                                        <a href=".jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Gestisci prodotti
                                        </a>
                                        <a href="/Amazoff/ServletLogout" class="list-group-item active">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Esci
                                        </a>
                                      <%
                                    }
                                    else if(userType.equals("2")) //admin
                                    { %>
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
                                        <a href=".jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Notifiche
                                        </a>
                                        <a href="/Amazoff/ServletLogout" class="list-group-item active">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Esci
                                        </a>
                                      <%
                                    }
                                 %>
                          </ul>   
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
                window.location = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value;
            }
        </script>
    </body>
</html>
