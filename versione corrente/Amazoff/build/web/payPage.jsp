<%-- 
    Document   : payPage
    Created on : 28-Oct-2017, 12:54:23
    Author     : Fra
--%>

<%@page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        
        <!-- non va piu il popover 
        <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script> -->
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        
        <title>Amazoff</title>
        <script>
            var jsonDatiUtente;
            function LogJson() {
                jsonDatiUtente = ${jsonPayPage};
                console.log(jsonDatiUtente);
                //RiempiBarraRicerca();
                //AggiungiProdotti();
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
                    toAdd += "<p><a href=\"#\" class=\"btn btn-primary\" role=\"button\">Vedi prodotto</a> <a href=\"/Amazoff/ServletAddToCart?productID=" + jsonProdotti.products[i].id + "\" class=\"btn btn-default\" role=\"button\">Aggiungi al carrello</a></p>";
                    toAdd += "</div>";
                    toAdd += "</div>";
                    toAdd += "</div>";
                }
                
                $("#zonaProdotti").html(toAdd);
            } */
            
            function RiempiBarraRicerca()
            {
                searchedProduct = jsonProdotti.searched;
                $("#txtCerca").val(searchedProduct);
            }
        </script>
            
    </head>
    <body class="bodyStyle">
       
        <div class="container-fluid tmargin">
            
            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>
            
            <div class="col-xs-12 col-lg-10">
                
                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
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

                                                    }catch(Exception ex){
                                                %>
                                                 Accedi 
                                                 <script>document.getElementById("iconAccediRegistrati").href="loginPage.jsp";</script>

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
                                                if(userType.equals("1") || userType.equals("2"))
                                                {
                                                    %>
                                                        <a href="notificationPage.jsp">
                                                        <span class="badge iconSize imgCenter" id="totNotifichexs"> 
                                                            <spam class="glyphicon glyphicon-inbox"></spam>
                                                            99+
                                                        </span>
                                                    </a>

                                                    <%
                                                }
                                            }catch(Exception ex){   }
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
                                                        <!-- PER ORA: se metto anche #profile, la pagina non si carica sull'oggetto con quel tag, ne prende i valori in get -->
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
                                                        <li><a href="userPage.jsp?v=Notifiche&i=tutte">Notifiche</a></li>
                                                        <li><a href="userPage.jsp">Negozio</a></li>
                                                        <li><a href="userPage.jsp?v=SellNewProduct#sellNewProduct">Vendi Prodotto</a></li>
                                                        <li><a href="userPage.jsp?v=GestisciProdotti#gestisciProdotti">Gestisci prodotti</a></li>
                                                        <li role="separator" class="divider"></li>
                                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                                        <li><a href="userPage.jsp?v=parametrov&a=parametroa#esci">Prova HREF</a></li>
                                                        <%
                                                    }
                                                    else if(userType.equals("2")) //admin
                                                    {
                                                        %>
                                                        <li><a href="userPage.jsp?v=Profilo#profilo">Profilo</a></li>
                                                        <li><a href="userPage.jsp?v=Notifiche&i=tutte">Notifiche</a></li>
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
                                   
                        <!-- CORPO pagina -->           
                        <!-- RIEPILOGO ORDINE -->
                        <div class="tmargin">
                            <h3>Riepilogo carrello</h3>
                            <div class="col-xs-12" id="zonaProdotti">
                                <!-- Prodotti di prova -->
                                <div class="row">
                                    <a href="ServletPopulateProductPage?id=id_oggetto" id="id_oggetto">
                                            <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                                <img src="UploadedImages/image3.jpg" style="max-height: 100px;" alt="...">
                                            </div>
                                            <div class="col-xs-8 col-md-5 col-lg-6">
                                                <div class="row">
                                                    <p id="nome" class="col-lg-12">Nome</p>
                                                    <p id="stelle" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni" >#num recensioni</p>
                                                    <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                    <h5 class="col-lg-12" id="prezzo+">Prezzo €</h5>                               
                                                </div>                        
                                            </div>
                                    </a>
                                </div>
                                
                                <div class="row">
                                    <a href="ServletPopulateProductPage?id=id_oggetto" id="id_oggetto">
                                            <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                                <img src="UploadedImages/image1.jpg" style="max-height: 100px;" alt="...">
                                            </div>
                                            <div class="col-xs-8 col-md-5 col-lg-6">
                                                <div class="row">
                                                    <p id="nome" class="col-lg-12">Nome</p>
                                                    <p id="stelle" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni" >#num recensioni</p>
                                                    <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                    <h5 class="col-lg-12" id="prezzo+">Prezzo €</h5>                               
                                                </div>                        
                                            </div>
                                    </a>
                                </div>
                                
                                <div class="row">
                                    <a href="ServletPopulateProductPage?id=id_oggetto" id="id_oggetto">
                                            <div class="thumbnail col-xs-4 col-lg-3" style="min-height:100px; ">
                                                <img src="UploadedImages/image.jpg" style="max-height: 100px;" alt="...">
                                            </div>
                                            <div class="col-xs-8 col-md-5 col-lg-6">
                                                <div class="row">
                                                    <p id="nome" class="col-lg-12">Nome</p>
                                                    <p id="stelle" class="col-xs-12 col-lg-3">Voto totale</p> <p  class="col-xs-12 col-lg-9" id="recensioni" >#num recensioni</p>
                                                    <p id="linkmappa" class="col-xs-12 col-lg-3">Vedi su mappa</p> <a href="url_venditore.html" class="col-xs-12 col-lg-3">Negozio</a>
                                                    <h5 class="col-lg-12" id="prezzo+">Prezzo €</h5>                               
                                                </div>                        
                                            </div>
                                    </a>
                                </div>
                            </div>                                                                    
                        </div>
                        
                        <!-- RIEPILOGO / inserisci nuovo INDIRIZZO -->
                        <div class="row col-xs-12 col-md-6 col-lg-6">
                            <div class="col-lg-12" >
                                <h3>Indirizzo di spedizione</h3>
                                <div class="row col-xs-12">
                                    <form class="form-group" id="LoginForm" name="FormIndirizzo" action="ServletDopoRegistrazione" method="POST" onsubmit="return checkDati();">
                                        <input name="paese" type="text" class="form-control" placeholder="Paese (si può anche fare a meno)" aria-describedby="sizing-addon2">
                                        <input name="indirizzo" type="text" class="form-control" placeholder="Indirizzo" aria-describedby="sizing-addon2">
                                        <input name="citta" type="text" class="form-control" placeholder="Città" aria-describedby="sizing-addon2">
                                        <input name="provincia" type="text" class="form-control" placeholder="Provincia" aria-describedby="sizing-addon2">
                                        <input name="cap" type="number" class="form-control" placeholder="Codice postale" aria-describedby="sizing-addon2">
                                    
                                        <button class="btn btn-primary" type="submit">Aggiorna</button>
                                    </form> 
                                </div>

                            </div>
                        </div>    
                        
                        <!-- RIEPILOGO / inserisci nuovi DATI CARTA CREDITO -->
                        <div class="row col-xs-12 col-md-6 col-lg-6" >
                            <div class="col-lg-12">    
                                <h3>Carta di credito</h3>
                                <div class="row col-xs-12">
                                    <input name="intestatario" type="text" class="form-control" placeholder="Intestatario" aria-describedby="sizing-addon2">
                                    <input name="numerocarta" type="number" class="form-control" placeholder="Numero carta" aria-describedby="sizing-addon2">

                                    <div style="align: left">Data di scadenza</div>
                                    <div>
                                        <div class="dropdown" style="display: inline-block">
                                                <select name="mesescadenza" class="btn btn-default dropdown-toggle" type="button" >
                                                  <%
                                                        String codice = "";
                                                        for (int i = 1; i <= 12; i++)
                                                        {
                                                            codice += "<option value=\""+i+"\">"+i+"</li>";
                                                        }
                                                    %>
                                                    <%= codice %>
                                                </select>
                                        </div>
                                        <div class="dropdown" style="display: inline-block;align: rigth ">


                                                <select name="annoscadenza" class="btn btn-default dropdown-toggle" type="button" >
                                                    <%
                                                        codice = "";
                                                        int year = new java.util.Date().getYear() + 1900 ;
                                                        for (int i = year; i <= year + 20; i++)
                                                        {
                                                            codice += "<option value=\""+i+"\">"+i+"</li>";
                                                        }
                                                    %>
                                                    <%= codice %>

                                                </select>
                                        </div>
                                    </div>

                                    <button class="btn btn-primary" type="submit">Aggiorna</button>
                                </div>
                            </div>
                        </div>
                                                    
                        <div class="row col-xs-12 alignCenter">
                                    <!-- TO DO: finche l'utente non inserisce i dati richiesti, non viene sbloccato il button.
                                        Se i dati sono già presenti perché vengono caricati dalla servlet, il btn è attivo
                                        Se l'utente modifica i dati, devo controllare che siano ancora validi prima di lasciargli completare l'ordine -->
                            <a href="orderCompletedPage.jsp?p=ok" class="btn btn-primary">Completa l'acquisto (prova: ok)</a>
                            <a href="orderCompletedPage.jsp?p=err" class="btn btn-danger">Completa l'acquisto (prova: error)</a>
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
            window.onscroll = function() { scrollFunction() };

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
            // TMP: leggo dati ricevuti dalla servlet
           LogJson();
        </script>
    </body>
</html>
