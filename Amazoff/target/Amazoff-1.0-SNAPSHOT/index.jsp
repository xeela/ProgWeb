<%-- 
    Document   : index
    Created on : 19-set-2017, 10.56.58
    Author     : Davide
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
        <div class="row">
            <div class="logo col-lg-1">
                LOGO
            </div>
            <div class="searchBar col-lg-8">
                <div class="input-group">
                    <input type="text" class="form-control" aria-label="...">
                    <div class="input-group-btn">
                      <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Prodotto <span class="caret"></span></button>
                      <ul class="dropdown-menu dropdown-menu-right">
                        <li><a href="#">Prodotto</a></li>
                        <li><a href="#">Categoria</a></li>
                        <li><a href="#">Luogo</a></li>
                      </ul>
                      <button class="btn btn-default" type="button">Cerca</button>
                    </div><!-- /btn-group -->
                </div><!-- /input-group -->
            </div>
            <div class="dropdownUtente col-lg-2">
                <div class="dropdown">
                    <button class="btn btn-default dropdown-toggle" type="button" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                      Profilo
                      <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1">
                      <li><a href="#">Accedi</a></li>
                      <li><a href="#">Registrati</a></li>
                    </ul>
                </div>
            </div>
            <div class="col-lg-1">
                <button type="button" class="btn btn-default btn-md">
                    <span class="glyphicon glyphicon-shopping-cart" aria-hidden="true"></span>
                </button>
            </div>
        </div>
        <div class="row">
            <nav class="navbar navbar-default col-lg-12">
                <div class="container-fluid">
                  <div class="navbar-header">
                      <p class="navbar-text">Home</p>
                  </div>
                </div>
            </nav>
        </div>
        
        <div class="row">
            <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators">
                  <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                  <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                  <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                </ol>

                <!-- Wrapper for slides -->
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

                <!-- Controls -->
                <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
                  <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                  <span class="sr-only">Previous</span>
                </a>
                <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
                  <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                  <span class="sr-only">Next</span>
                </a>
              </div>
        </div>
        <div class="row" style="margin-top:40px">
                <div class="col-sm-6 col-md-4">
                  <div class="thumbnail">
                    <img src="images/doge.jpg" alt="...">
                    <div class="caption">
                      <h3>Prodotto Bello</h3>
                      <p>Descrizione bella</p>
                      <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-md-4">
                  <div class="thumbnail">
                    <img src="images/doge.jpg" alt="...">
                    <div class="caption">
                      <h3>Prodotto Bello</h3>
                      <p>Descrizione bella</p>
                      <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-md-4">
                  <div class="thumbnail">
                    <img src="images/doge.jpg" alt="...">
                    <div class="caption">
                      <h3>Prodotto Bello</h3>
                      <p>Descrizione bella</p>
                      <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                    </div>
                  </div>
                </div>
        </div>
        
                <div class="row">
                <div class="col-sm-6 col-md-4">
                  <div class="thumbnail">
                    <img src="images/doge.jpg" alt="...">
                    <div class="caption">
                      <h3>Prodotto Bello</h3>
                      <p>Descrizione bella</p>
                      <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-md-4">
                  <div class="thumbnail">
                    <img src="images/doge.jpg" alt="...">
                    <div class="caption">
                      <h3>Prodotto Bello</h3>
                      <p>Descrizione bella</p>
                      <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                    </div>
                  </div>
                </div>
                <div class="col-sm-6 col-md-4">
                  <div class="thumbnail">
                    <img src="images/doge.jpg" alt="...">
                    <div class="caption">
                      <h3>Prodotto Bello</h3>
                      <p>Descrizione bella</p>
                      <p><a href="#" class="btn btn-primary" role="button">Vedi prodotto</a> <a href="#" class="btn btn-default" role="button">Aggiungi al carrello</a></p>
                    </div>
                  </div>
                </div>
        </div>
        
        <div class="row">
            
        </div>
        
    </body>
</html>
