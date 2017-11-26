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
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
        
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle darkBody">
        
        
        <!-- TODO: 1. aggiungere un bottone per la sezione NOTIFICHE, per l'utente venditore -->
        
        <!-- PROVA BOOTSTRAP 
        <div class="container-fluid">
        <div class="row">
            <!-- xs per smartphone lg per tablet e pc --
            <div class="col-xs-12 col-lg-4" style="background-color: green"><button class="col-xs-12">button</button></div>
            <div class="hidden-xs col-lg-4" style="background-color: red">col-xs-8</div>
            <div class="col-xs-4 col-lg-3" style="background-color: aqua">col-xs-4</div>
          </div>
        </div> -->
            
        <div class="container-fluid">
            
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
                        <!-- barra con: login/registrati, cerca, carrello -->
                        <div class="logo col-xs-12 col-lg-1">
                            <div class="row">
                                <div class="col-xs-6 col-lg-10"><a href="index.jsp">
                                        <img src="images/logo/logodark.png" alt="Amazoff"/>
                                    </a></div>
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
                        <div class="searchBar col-xs-12 col-lg-7">
                            <div class="input-group">
                                <input type="text" class="form-control" aria-label="...">
                                
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
                                        <a href="userPage.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
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
                                    
                                    
                                    <!--<span class="caret"></span>-->
                                                <!--<ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                                                  <li><a href="loginPage.jsp">Accedi</a></li>
                                                  <li><a href="loginPage.jsp">Registrati</a></li>
                                                </ul-->
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
                                                  <li><a href="#">Prodotto</a></li>
                                                  <li><a href="#">Categoria</a></li>
                                                  <li><a href="#">Luogo</a></li>
                                                </ul>
                                            </div>
                                            <div class="navbar-header col-xs-4">
                                                <p class="navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                                    <span class="glyphicon glyphicon-filter"></span>
                                                </p>
                                                <ul class="dropdown-menu dropdown-menu-right col-xs-8 hidden-sm hidden-md hidden-lg"> <!-- ?????????? sull'ipad non sparisce -->
                                                  <li><a href="#">Prodotto</a></li>
                                                  <li><a href="#">Categoria</a></li>
                                                  <li><a href="#">Luogo</a></li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </nav>
                            
                            </div>
                            
                        </div>
                </div>
           
                <!-- PROVA -->
                <!-- barra del menu OSS: si potrebbe fare che sui dispositivi sm diventa un menu a tendina --    
            <div class="row menuBar">            
                <nav class="navbar navbar-default col-lg-12">
                    <div class="container-fluid">
                      <div class="navbar-header col-lg-3">
                          <p class="navbar-text">Home1</p>
                      </div>
                      <div class="navbar-header col-lg-3">
                          <p class="navbar-text">Home2</p>
                      </div>
                      <div class="navbar-header col-lg-3">
                          <p class="navbar-text">Home3</p>
                      </div>
                      <div class="navbar-header col-lg-3">
                          <p class="navbar-text">Home4</p>
                      </div>
                    </div>
                </nav>
            </div> -->
                    
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
                            <div class="carousel-caption">
                              <h3>Chania</h3>
                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>
                            </div>
                          </div>

                          <div class="item">
                            <img src="images/img2.jpg" alt="Chania">
                            <div class="carousel-caption">
                              <h3>Chania</h3>
                              <p>The atmosphere in Chania has a touch of Florence and Venice.</p>
                            </div>
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
            
            <!-- PROVE -->
            <!-- galleria immagine animata 
                <div class="row">

                    <div class="carousel slide" id="carousel-example-generic"  data-ride="carousel">
                        <!-- Indicators 
                        <ol class="carousel-indicators">
                          <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                          <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                          <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                        </ol>

                        <!-- Wrapper for slides
                        <div class="carousel-inner" role="listbox">
                          <div class="item active">
                            <img src="images/img1.jpg" alt="...">
                          </div>
                          <div class="item">
                            <img src="images/img2.jpg" alt="...">
                          </div>
                            <div class="item">
                            <img src="images/img3.jpg" alt="...">
                          </div>
                        </div>

                        <!-- Controls
                        <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                          <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                          <span class="sr-only">Previous</span>
                        </a>
                        <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                          <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                          <span class="sr-only">Next</span>
                        </a>
                    </div>
                </div>-->
            <!--<div class="row">

            <div class="col-lg-4 col-md-6 mb-4">
              <div class="card h-100">
                <a href="#"><img class="card-img-top" src="http://placehold.it/700x400" alt=""></a>
                <div class="card-body">
                  <h4 class="card-title">
                    <a href="#">Item One</a>
                  </h4>
                  <h5>$24.99</h5>
                  <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">&#9733; &#9733; &#9733; &#9733; &#9734;</small>
                </div>
              </div>
            </div>

            <div class="col-lg-4 col-md-6 col-xs-5">
              <div class="card h-100">
                <a href="#"><img class="card-img-top" src="http://placehold.it/700x400" alt=""></a>
                <div class="card-body">
                  <h4 class="card-title">
                    <a href="#">Item Two</a>
                  </h4>
                  <h5>$24.99</h5>
                  <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur! Lorem ipsum dolor sit amet.</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">&#9733; &#9733; &#9733; &#9733; &#9734;</small>
                </div>
              </div>
            </div>

            <div class="col-lg-4 col-md-6 col-sm-5">
              <div class="card h-100">
                <a href="#"><img class="card-img-top" src="images/doge.jpg" alt=""></a>
                <div class="card-body">
                  <h4 class="card-title">
                    <a href="#">Item Three</a>
                  </h4>
                  <h5>$24.99</h5>
                  <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">&#9733; &#9733; &#9733; &#9733; &#9734;</small>
                </div>
              </div>
            </div>

            <div class="col-lg-4 col-md-6 col-xs-5">
              <div class="card h-100">
                <a href="#"><img class="card-img-top" src="http://placehold.it/700x400" alt=""></a>
                <div class="card-body">
                  <h4 class="card-title">
                    <a href="#">Item Four</a>
                  </h4>
                  <h5>$24.99</h5>
                  <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">&#9733; &#9733; &#9733; &#9733; &#9734;</small>
                </div>
              </div>
            </div>

            <div class="col-lg-4 col-md-6 mb-4">
              <div class="card h-100">
                <a href="#"><img class="card-img-top" src="http://placehold.it/700x400" alt=""></a>
                <div class="card-body">
                  <h4 class="card-title">
                    <a href="#">Item Five</a>
                  </h4>
                  <h5>$24.99</h5>
                  <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur! Lorem ipsum dolor sit amet.</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">&#9733; &#9733; &#9733; &#9733; &#9734;</small>
                </div>
              </div>
            </div>

            <div class="col-lg-4 col-md-6 mb-4">
              <div class="card h-100">
                <a href="#"><img class="card-img-top" src="http://placehold.it/700x400" alt=""></a>
                <div class="card-body">
                  <h4 class="card-title">
                    <a href="#">Item Six</a>
                  </h4>
                  <h5>$24.99</h5>
                  <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Amet numquam aspernatur!</p>
                </div>
                <div class="card-footer">
                  <small class="text-muted">&#9733; &#9733; &#9733; &#9733; &#9734;</small>
                </div>
              </div>
            </div>

          </div> -->
                        
         
                <!-- tabella di 2 righe, con 3 colonne, che mostrano 6 prodotti -->
                <div class="row">
                <div class="page">
                        <div class="col-sm-6 col-md-4">
                          <div class="thumbnail darkPanel">
                            <img src="images/doge.jpg" alt="...">
                            <div class="caption">
                              <h3 class="whiteText"> Prodotto Bello</h3>
                              <p class="whiteText">Descrizione bella</p>
                              <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                            </div>
                          </div>
                        </div>
                                               
                    <div class="col-sm-6 col-md-4">
                          <div class="thumbnail darkPanel">
                            <img src="images/doge.jpg" alt="...">
                            <div class="caption">
                              <h3 class="whiteText"> Prodotto Bello</h3>
                              <p class="whiteText">Descrizione bella</p>
                              <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                            </div>
                          </div>
                        </div>                        
                    <div class="col-sm-6 col-md-4">
                          <div class="thumbnail darkPanel">
                            <img src="images/doge.jpg" alt="...">
                            <div class="caption">
                              <h3 class="whiteText"> Prodotto Bello</h3>
                              <p class="whiteText">Descrizione bella</p>
                              <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                            </div>
                          </div>
                        </div>                        
                        <div class="col-sm-6 col-md-4">
                          <div class="thumbnail darkPanel">
                            <img src="images/doge.jpg" alt="...">
                            <div class="caption">
                              <h3 class="whiteText"> Prodotto Bello</h3>
                              <p class="whiteText">Descrizione bella</p>
                              <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                            </div>
                          </div>
                        </div>                        
                        <div class="col-sm-6 col-md-4">
                          <div class="thumbnail darkPanel">
                            <img src="images/doge.jpg" alt="...">
                            <div class="caption">
                              <h3 class="whiteText"> Prodotto Bello</h3>
                              <p class="whiteText">Descrizione bella</p>
                              <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                            </div>
                          </div>
                        </div>                        
                        <div class="col-sm-6 col-md-4">
                          <div class="thumbnail darkPanel">
                            <img src="images/doge.jpg" alt="...">
                            <div class="caption">
                              <h3 class="whiteText"> Prodotto Bello</h3>
                              <p class="whiteText">Descrizione bella</p>
                              <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                            </div>
                          </div>
                        </div>
                        
                </div>
            </div>
            
            <!-- barra bianca a dx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <!-- back to top button -->
            <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>
            
            <!-- footer -->
            <footer style="background-color: red">
                <p>&copy; Company 2017</p>
            </footer>
            
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
