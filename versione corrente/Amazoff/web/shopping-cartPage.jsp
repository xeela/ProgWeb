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
        <!-- js per l'icona del pagamento -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle">
       
        <div class="container-fluid">
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
                        <!-- barra con: login/registrati, cerca, carrello -->
                        <div class="logo col-xs-12 col-lg-1">
                            <div class="row">
                                <div class="col-xs-8 col-lg-10"><a href="index.jsp">LOGO</a></div>
                                <div class="col-xs-4 hidden-lg" style="text-align: right"> 
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
                            </div>
                        </div>
                        <!-- SEARCH BAR -->
                        <div class="searchBar col-xs-12 col-lg-7">
                            <div class="input-group">
                                
                                <div class="input-group-btn">
                                  <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Filtri <span class="caret"></span></button>
                                  <ul class="dropdown-menu dropdown-menu-left hidden-xs"> 
                                    <li><a href="#">Vicinanza</a></li>
                                    <li><a href="#">Prezzo</a></li>
                                    <li><a href="#">Recensione</a></li>
                                  </ul>
                                </div>
                                
                                <input id="txtCerca" type="text" class="form-control" aria-label="..." placeholder="Cosa vuoi cercare?">
                                
                                <div class="input-group-btn">
                                  <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">Scegli categoria<span class="caret"></span></button>
                                  <ul class="dropdown-menu dropdown-menu-left hidden-xs"> 
                                    <li><a href="#">Categoria</a></li>
                                    <li><a href="#">Oggetto</a></li>
                                    <li><a href="#">Venditore</a></li>
                                  </ul>
                                  <a class="btn btn-default" type="button" onclick="cercaProdotto('txtCerca')">Cerca</a> <!-- **** onclick è temporaneo, andrà sostituito con la chiamanta alla servlet che genera la pagina search in base al dato passato -->
                                </div><!-- /btn-group --> 
                            </div><!-- /input-group -->
                        </div>                     
                        
                        <!-- button: accedi/registrati e carrello per PC -->
                        <div class="hidden-xs hidden-sm hidden-md col-lg-4">
                        
                            <div class="row">                                
                                <div class="dropdownUtente col-lg-10" >
                                    <div class="btn-group">
                                        <a href="paginaUtenteDaCreare.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
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
                                                        <li><a href=".jsp">Diventa venditore</a></li>
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

                            </div>
                        </div>
                            
                        
                </div>
  
                <div class="row tmargin">
                    <div class="col-12">
                        <div class="row">
                            <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                    <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                        <img src="images/img1.jpg" style="max-height: 100px; " alt="...">
                                    </div>
                                        <div class="col-xs-8 col-md-5 col-lg-6">

                                            <div class="row">
                                                <p id="nome+" class="col-lg-12" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->

                                                <p id="stelle+" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni+" >#num recensioni</p>
                                                <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                <h5 class="col-lg-12" id="prezzo+">Prezzo</h5>                               
                                            </div>                        

                                        </div>
                                    
                                 <div class="col-xs-4 col-lg-3" style="min-height:100px; ">
                                    </div>   
                                <div class="col-xs-8 col-md-3 col-lg-2" > <!-- style="background-color: aqua; position: absolute;" -->
                                    <div >
                                        <button class="btn btn-primary col-lg-3" onclick="alert('incrementa')"><span class="glyphicon glyphicon-plus"></span></button>
                                        <p class="btn col-lg-3" id="numProduct+idlettodaldb">1</p>
                                        <button class="btn btn-danger col-lg-3" onclick="alert('decrementa')"><span class="glyphicon glyphicon-minus"></span></button>
                                        <button class="btn btn-warning col-lg-3"><span class="glyphicon glyphicon-trash"></span></button>
                                    </div>
                                 </div>
                            </a>
                        </div>
                        
                        <div class="row">
                            <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                    <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                        <img src="images/img1.jpg" style="max-height: 100px; " alt="...">
                                    </div>
                                        <div class="col-xs-8 col-md-5 col-lg-6">

                                            <div class="row">
                                                <p id="nome+" class="col-lg-12" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->

                                                <p id="stelle+" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni+" >#num recensioni</p>
                                                <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                <h5 class="col-lg-12" id="prezzo+">Prezzo</h5>                               
                                            </div>                        

                                        </div>
                                    
                                 <div class="col-xs-4 col-lg-3" style="min-height:100px; ">
                                    </div>   
                                <div class="col-xs-8 col-md-3 col-lg-2" > <!-- style="background-color: aqua; position: absolute;" -->
                                    <div >
                                        <button class="btn btn-primary col-lg-3" onclick="alert('incrementa')"><span class="glyphicon glyphicon-plus"></span></button>
                                        <p class="btn col-lg-3" id="numProduct+idlettodaldb">1</p>
                                        <button class="btn btn-danger col-lg-3" onclick="alert('decrementa')"><span class="glyphicon glyphicon-minus"></span></button>
                                        <button class="btn btn-warning col-lg-3"><span class="glyphicon glyphicon-trash"></span></button>
                                    </div>
                                 </div>
                            </a>
                        </div>
                        
                        <div class="row">
                            <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                    <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                        <img src="images/img1.jpg" style="max-height: 100px; " alt="...">
                                    </div>
                                        <div class="col-xs-8 col-md-5 col-lg-6">

                                            <div class="row">
                                                <p id="nome+" class="col-lg-12" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto-->

                                                <p id="stelle+" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni+" >#num recensioni</p>
                                                <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                <h5 class="col-lg-12" id="prezzo+">Prezzo</h5>                               
                                            </div>                        

                                        </div>
                                    
                                 <div class="col-xs-4 col-lg-3" style="min-height:100px; ">
                                    </div>   
                                <div class="col-xs-8 col-md-3 col-lg-2" > <!-- style="background-color: aqua; position: absolute;" -->
                                    <div >
                                        <button class="btn btn-primary col-lg-3" onclick="alert('incrementa')"><span class="glyphicon glyphicon-plus"></span></button>
                                        <p class="btn col-lg-3" id="numProduct+idlettodaldb">1</p>
                                        <button class="btn btn-danger col-lg-3" onclick="alert('decrementa')"><span class="glyphicon glyphicon-minus"></span></button>
                                        <button class="btn btn-warning col-lg-3"><span class="glyphicon glyphicon-trash"></span></button>
                                    </div>
                                 </div>
                            </a>
                        </div>
                    </div>                                                                    
                </div>                          
                                             
                <!-- button che porta alla pagina fittizia di pagamento -->
                <button id="btnAcquista" class="col-xs-4 col-lg-1" title="Procedi con l'acquisto."><a href="payPage.jsp" style="text-decoration: none">Paga <i class="fa fa-credit-card"></i><a></button>

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
        <br><br>
            
            
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
