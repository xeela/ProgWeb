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
                                <div class="col-xs-8 col-lg-10"><a href="index.jsp">Amazoff</a></div>
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
                                      <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Scegli categoria<span class="caret"></span></button>
                                      <ul class="dropdown-menu dropdown-menu-left hidden-xs"> 
                                        <li><a href="#">Categoria</a></li>
                                        <li><a href="#">Oggetto</a></li>
                                        <li><a href="#">Venditore</a></li>
                                      </ul>
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
                                        <a href="userPage.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
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
                                        <a href="userPage.jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Profilo
                                        </a>
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
                                        <a href="userPage.jsp" class="list-group-item">
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
                                        <a href="userPage.jsp" class="list-group-item">
                                          <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                          Profilo
                                        </a>
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
