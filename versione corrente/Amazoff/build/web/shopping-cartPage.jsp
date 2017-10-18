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
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        <script type="text/javascript" src="js/json_sort.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        <script type="text/javascript">
            var cart;
            function LogCart()
            {
                // oss: se non si aggiunge un oggetto dalla home, anche se shoppingCartProducts conterrebbe valori, non vengono trovati
                cart = ${shoppingCartProducts};
                console.log(cart);
                AggiungiProdotti(cart);
            }
            
            // funzione che dovrà essere spostata nel file json_sort.js
            function AggiungiProdotti(cart)
            {
                var toAdd = "";
                var id_oggetto = -1

                $("#zonaProdotti").html(toAdd);

                // visualizzo i prodotti del carrello, da quello aggiunto più di recente al più vecchio
                for (var i = cart.products.length - 1; i >= 0; i--)
                {
                    id_oggetto = cart.products[i].id;
                    toAdd += "<div class=\"row\">";
                    toAdd += "        <a href=\"ServletPopulateProductPage?id="+id_oggetto+"\" id=\""+id_oggetto+"\">";
                    toAdd += "                <div class=\"thumbnail col-xs-4 col-lg-3\" style=\"min-height:100px; \">";
                    toAdd += "                    <img src=\"UploadedImages/"+cart.products[i].pictures[0].path+"\" style=\"max-height: 100px; \" alt=\"...\">";
                    toAdd += "                </div>";
                    toAdd += "                    <div class=\"col-xs-8 col-md-5 col-lg-6\">";
                    toAdd += "                        <div class=\"row\">";
                    toAdd += "                            <p id=\"nome"+id_oggetto+"\" class=\"col-lg-12\" >"+cart.products[i].name+"</p>";
                    toAdd += "                            <p id=\"stelle"+id_oggetto+"\" class=\"col-xs-12 col-lg-3\">Voto totale</p> <p  class=\"col-xs-12 col-lg-9\" id=\"recensioni"+id_oggetto+"\" >#num recensioni</p>";
                    toAdd += "                            <p id=\"linkmappa"+id_oggetto+"\" class=\"col-xs-12 col-lg-3\">Vedi su mappa</p> <a href=\"url_venditore.html\" class=\"col-xs-12 col-lg-3\">Negozio</a>";
                    toAdd += "                            <h5 class=\"col-lg-12\" id=\"prezzo"+id_oggetto+"\">Prezzo: "+cart.products[i].price+" €</h5>";                         
                    toAdd += "                        </div>";                     
                    toAdd += "                   </div>";
                    toAdd += "            <div class=\"col-xs-4 col-lg-3\" style=\"min-height:100px; \">";
                    toAdd += "            </div>";
                    toAdd += "           <div class=\"col-xs-8 col-md-3 col-lg-2\" >"; 
                    toAdd += "                   <button class=\"btn btn-warning\" onclick=\"removeFromCart("+i+","+id_oggetto+")\"><span class=\"glyphicon glyphicon-trash\"></span></button>";
                    toAdd += "            </div>";
                    toAdd += "        </a>";
                    toAdd += "</div>";
                }

                $("#zonaProdotti").html(toAdd);
                
            }
            
            function removeFromCart(indexElement, idElement)
            {
                // rimuovo l'elemento dal vettore json di dati
                cart.products.splice(indexElement,1);
                
                // salva la modifica sul DB
                /* ..... */
                
                // TMP
                AggiungiProdotti(cart);
                
                
            }
            
        </script>
        
        <title>Amazoff</title>
    </head>
    <body class="bodyStyle" onload="LogCart()">
       
        <div class="container-fluid tmargin">
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
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
                                                <div class="col-xs-3 hidden-lg" style="text-align: right;">
                                                    <span class="badge"><a href="notificationPage.jsp"> <spam class="glyphicon glyphicon-inbox"></spam> 11</a></span>
                                                 </div>
                                                <%
                                            }
                                        }catch(Exception ex){   }
                                %> 
                                </div>
                        </div>
                        <!-- SEARCH BAR -->
                        <div class="searchBar col-xs-12 col-lg-7">
                            <div>
                                <form id="formSearch" class="input-group" method="get" action="/Amazoff/ServletFindProduct" >
                                    <div class="input-group-btn">
                                      <button type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-filter"></span></button>
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
                                <div class="dropdownUtente col-lg-8" >
                                    <div class="btn-group">
                                        <a href="userPage.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
                                            <% 
                                                userType = "";
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
                                                        <li><a href="profilePage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Rimborso / Anomalia</a></li>
                                                        <li><a href=".jsp">Diventa venditore</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("1")) // venditore
                                                    {
                                                        %>
                                                        <li><a href="profilePage.jsp">Profilo</a></li>
                                                        <li><a href=".jsp">Notifiche</a></li>
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
                            </div>
                        </div>
                            
                        
                </div>
  
                <div class="tmargin">
                    <div class="col-xs-12" id="zonaProdotti">
                        <!--<div class="row">
                            <a href="productPage.jsp?id=id_oggetto" id="id_oggetto">
                                    <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                        <img src="images/img1.jpg" style="max-height: 100px; " alt="...">
                                    </div>
                                        <div class="col-xs-8 col-md-5 col-lg-6">

                                            <div class="row">
                                                <p id="nome+" class="col-lg-12" >Nome</p> <!-- OSS: ID: +dovra essere aggiunto dinamicamente l'id del prodotto--

                                                <p id="stelle+" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni+" >#num recensioni</p>
                                                <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                <h5 class="col-lg-12" id="prezzo+">Prezzo</h5>                               
                                            </div>                        

                                        </div>
                                    
                                <div class="col-xs-4 col-lg-3" style="min-height:100px; ">
                                </div>   
                                <div class="col-xs-8 col-md-3 col-lg-2" > 
                                        <button class="btn btn-warning"><span class="glyphicon glyphicon-trash"></span></button>
                                </div>
                            </a>
                        </div> -->
                        
                    </div>                                                                    
                </div>                          
                                             
                <!-- button che porta alla pagina fittizia di pagamento -->
                <button id="btnAcquista" class="col-lg-1" title="Procedi con l'acquisto."><a href="payPage.jsp" style="text-decoration: none">Paga <i class="fa fa-credit-card"></i><a></button>

                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer -- ROMPE TUTTO
                <footer style="background-color: red">
                    <p>&copy; Company 2017</p>
                </footer> -->
            
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
