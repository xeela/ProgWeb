<%-- 
    Document   : payPage
    Created on : 28-Oct-2017, 12:54:23
    Author     : Francesco Bruschetti
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
        <script type="text/javascript" src="js/parametri-ricerca.js"></script>

        <link rel="stylesheet" href="css/amazoffStyle.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />

        <title>Amazoff</title>
        <script>
            var userID = "<%= session.getAttribute("userID")%>";
            var modalita = "null"; // vale: spedizione oppure ritiro. null se non ancora selezionata
            var datiIndirizzo = "false"; // true = validi. false = non validi
            var datiCarta = "false";
            var jsonNotifiche = ${jsonNotifiche};

            // ottengo i dati json contenenti i dati dell'utente
            var jsonDatiUtente;
            var cartReceived;
            var datiok = false; // dati utente e carta di credito
            ottieniJson();

            function ottieniJson()
            {
                jsonDatiUtente = ${jsonPayPage};
                cartReceived = ${shoppingCartProducts};

                console.log(jsonDatiUtente);
                console.log(cartReceived);

            }

            // funzione che inserisce nella form, l'indirizzo dell'utente
            function AggiungiDatiUtente() {
                if (jsonDatiUtente.addressdata.length != 0)
                {
                    var toAdd = "";

                    if (jsonDatiUtente.addressdata.length > 0) {
                        datiIndirizzo = "true";
                        $("#paese").val(jsonDatiUtente.addressdata[0].town);
                        $("#indirizzo").val(jsonDatiUtente.addressdata[0].address);
                        $("#citta").val(jsonDatiUtente.addressdata[0].city);
                        $("#provincia").val(jsonDatiUtente.addressdata[0].province);
                        $("#cap").val(jsonDatiUtente.addressdata[0].postal_code);
                    }
                }
            }

            // funzione che inserisce nella form, i dati della carta di credito
            function AggiungiDatiMetodoPagamento() {
                if (jsonDatiUtente.paymentdata.length != 0)
                {
                    var toAdd = "";
                    console.log("2");
                    console.log("a: " + jsonDatiUtente.paymentdata[0].owner);
                    console.log("b: " + jsonDatiUtente.paymentdata[0].card_number);
                    console.log("c: " + jsonDatiUtente.paymentdata[0].exp_month);
                    console.log("d: " + jsonDatiUtente.paymentdata[0].exp_year);
                    if (jsonDatiUtente.paymentdata.length > 0) {
                        datiCarta = "true";

                        $("#intestatario").val(jsonDatiUtente.paymentdata[0].owner);
                        $("#numerocarta").val(jsonDatiUtente.paymentdata[0].card_number);

                        $("#mesescadenza").val("" + jsonDatiUtente.paymentdata[0].exp_month);
                        $("#annoscadenza").val("" + jsonDatiUtente.paymentdata[0].exp_year);
                    }
                }
            }

            function AggiungiProdotti(cart)
            {
                var toAdd = "";
                var id_oggetto = -1;

                // visualizzo i prodotti del carrello, da quello aggiunto più di recente al più vecchio
                for (var i = cart.products.length - 1; i >= 0; i--)
                {
                    id_oggetto = cart.products[i].id;
                    toAdd += "<div class=\"row\">";
                    toAdd += "        <a href=\"ServletPopulateProductPage?id=" + id_oggetto + "\" id=\"" + id_oggetto + "\">";
                    toAdd += "                <div class=\"thumbnail col-xs-4 col-lg-3\" style=\"min-height:100px; \">";
                    toAdd += "                    <img src=\"UploadedImages/" + cart.products[i].pictures[0].path + "\" style=\"max-height: 100px; \" alt=\"...\">";
                    toAdd += "                </div>";
                    toAdd += "                    <div class=\"col-xs-8 col-md-5 col-lg-6\">";
                    toAdd += "                        <div class=\"row\">";
                    toAdd += "                            <p id=\"nome" + id_oggetto + "\" class=\"col-lg-12\" >" + cart.products[i].name + "</p>";
                    toAdd += "                            <p id=\"stelle" + id_oggetto + "\" class=\"col-xs-12 col-lg-3\">Voto totale</p> <p  class=\"col-xs-12 col-lg-9\" id=\"recensioni" + id_oggetto + "\" >#num recensioni</p>";
                    toAdd += "                            <p id=\"linkmappa" + id_oggetto + "\" class=\"col-xs-12 col-lg-3\">Vedi su mappa</p> <a href=\"url_venditore.html\" class=\"col-xs-12 col-lg-3\">Negozio</a>";
                    toAdd += "                            <h5 class=\"col-lg-12\" id=\"prezzo" + id_oggetto + "\">Prezzo: " + cart.products[i].price + " €</h5>";
                    toAdd += "                        </div>";
                    toAdd += "                   </div>";
                    toAdd += "            <div class=\"col-xs-4 col-lg-3\" style=\"min-height:100px; \">";
                    toAdd += "            </div>";
                    toAdd += "           <div class=\"col-xs-8 col-md-3 col-lg-2\" >";
                    toAdd += "                   <button class=\"btn btn-warning\" onclick=\"removeFromCart(" + i + "," + id_oggetto + ")\"><span class=\"glyphicon glyphicon-trash\"></span></button>";
                    toAdd += "            </div>";
                    toAdd += "        </a>";
                    toAdd += "</div>";
                }

                $("#zonaProdotti").html(toAdd);
            }

            function RiempiBarraRicerca()
            {
                searchedProduct = jsonProdotti.searched;
                $("#txtCerca").val(searchedProduct);
            }

            /* funzione che visualizza / nasconde la form della carta di credito in base al tipo di acquisto */
            function checkModalita(selectedMode)
            {
                modalita = selectedMode;

                if (modalita === "ritiro") {
                    $("#div_creditcard").fadeOut("slow", function () {  /* Animation complete.*/
                    });
                    document.getElementById("ritiro").disabled = true;
                    document.getElementById("spedizione").disabled = false;
                } else
                {
                    $("#div_creditcard").fadeIn("slow", function () {  /* Animation complete.*/
                    });
                    document.getElementById("spedizione").disabled = true;
                    document.getElementById("ritiro").disabled = false;
                }
                enabledBtnAcquista(modalita);
            }

            function enabledBtnAcquista(op)
            {
                //alert("STATO: " + op + " " + datiIndirizzo + " " + datiCarta);
                if (op == "ritiro") {
                    if (datiIndirizzo == "true") {
                        document.getElementById("btnCompletaAcquisto").disabled = false;
                        document.getElementById("txtmodalita").value = modalita;
                    }
                } else if (op == "spedizione") {
                    if (datiIndirizzo == "true" && datiCarta == "true") {
                        document.getElementById("btnCompletaAcquisto").disabled = false;
                        document.getElementById("txtmodalita").value = modalita;
                    } else {
                        document.getElementById("btnCompletaAcquisto").disabled = true;
                        document.getElementById("btnCompletaAcquisto").title = "Controlla di aver inserito dati validi prima di continuare.";
                    }
                }
            }

            function  completaOrdine(stato)
            {
                window.location = "ServletConfirmOrder";
            }

            // chiamata ajax che controlla che i dati siano stati modificati correttamente
            function checkDatiIndirizzo()
            {
                //$("#indirizzoLoading").html("<i class=\"fa fa-spinner fa-spin\"></i>");
                var paese = $("#paese").val();
                var indirizzo = $("#indirizzo").val();
                var citta = $("#citta").val();
                var provincia = $("#provincia").val();
                var cap = $("#cap").val();

                if (paese == "" || indirizzo == "" || citta == "" || provincia == "" || cap == "")
                {
                    enabledBtnAcquista("null");
                    alert("Completa tutti i campi prima di continuare");

                    return false; // uno o più campi sono vuoti
                } else {

                    $.post('ServletAjaxPayPage', {
                        _op: "indirizzo",
                        _user: userID,
                        _paese: paese,
                        _indirizzo: indirizzo,
                        _citta: citta,
                        _provincia: provincia,
                        _cap: cap,
                        _ritiroOspedizione: modalita
                    }, function (data) {
                        datiIndirizzo = data;
                        //alert(datiIndirizzo);
                        // se i dati ricevuti sono validi, ed è gia stata scelta la modalità di acq. ALLORA controllo se sbloccare il btnAcq
                        if ((datiIndirizzo) && modalita != "null") {
                            enabledBtnAcquista(modalita);
                        }

                    }).fail(function () {
                        alert("ERR");
                    });
                }
                //$("#").html("<span class=\"glyphicon glyphicon-user\"></span>");
                //return false;
            }

            function checkDatiCarta()
            {
                //$("#indirizzoLoading").html("<i class=\"fa fa-spinner fa-spin\"></i>");
                var intestatario = $("#intestatario").val();
                var numerocarta = $("#numerocarta").val();
                var meseScadenza = $("#mesescadenza").val();
                var annoScadenza = $("#annoscadenza").val();

                if (intestatario == "" || numerocarta == "" || meseScadenza == "" || annoScadenza == "")
                {
                    enabledBtnAcquista("null");
                    alert("Completa tutti i campi prima di continuare");
                    return false; // uno o più campi sono vuoti
                } else {

                    $.post('ServletAjaxPayPageCard', {
                        _intestatario: intestatario,
                        _numerocarta: numerocarta,
                        _meseScadenza: meseScadenza,
                        _annoScadenza: annoScadenza,
                        _ritiroOspedizione: modalita,
                    }, function (data) {
                        datiCarta = data;
                        //alert(datiCarta);
                        // se i dati ricevuti sono validi, ed è gia stata scelta la modalità di acq. ALLORA controllo se sbloccare il btnAcq
                        if ((datiCarta) && modalita != "null") {
                            enabledBtnAcquista(modalita);
                        }
                    }).fail(function () {
                        alert("ERR");
                    });
                }
                //$("#").html("<span class=\"glyphicon glyphicon-user\"></span>");
                //return false;
            }

            function datiModificati(div)
            {
                if (div == "indirizzo")
                    datiIndirizzo = "false";
                else
                    datiCarta = "false";

                enabledBtnAcquista("in_attesa_validazione");

            }
        </script>

    </head>
    <body class="bodyStyle" onload="Autocomplete('product')">

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
                                            %>
                                            <!-- memorizzo l'id dell'utente, cosi da usarlo per controllare i suoi dati (indirizzo e carta) -->
                                            <script>user = "<%=user%>"</script> 
                                            <%
                                                }catch(Exception ex){
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
                                    <a href="ServletAddToCart"">
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
                                <div id="parametriRicerca">
                                    <input id="categoriaRicerca" name="categoriaRicerca" type="text" style="display:none;" value="product">
                                </div>
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
                                        <!-- PER ORA: se metto anche #profile, la pagina non si carica sull'oggetto con quel tag, ne prende i valori in get -->
                                        <li><a href="userPage.jsp?v=Profile#profilo">Profilo</a></li>
                                        <li><a href="ServletMyOrders">Miei ordini</a></li>
                                        <li><a href="userPage.jsp">Rimborso / Anomalia</a></li>
                                        <li><a href="userPage.jsp?v=CreateShop#createshop">Diventa venditore</a></li>
                                        <li role="separator" class="divider"></li>
                                        <li><a href="/Amazoff/ServletLogout">Esci</a></li>
                                            <%
                                        }
                                        else if(userType.equals("1")) // venditore
                                        {
                                            %>
                                        <li><a href="userPage.jsp?v=Profile#profilo">Profilo</a></li>
                                        <li><a href="ServletMyOrders">Miei ordini</a></li>
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
                                        <li><a href="userPage.jsp?v=Profile#profilo">Profilo</a></li>
                                        <li><a href="ServletMyOrders">Miei ordini</a></li>
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
                                } 
                                catch (Exception ex) { }
                            %> 


                            <div class="col-lg-2">
                                <a href="ServletShowCart" type="button" class="btn btn-default btn-md">
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
                                                <input class="form-control" type="number" min="0" step="1" placeholder="KM Max" name="distanzaMax" onchange="impostaDistanzaWrapper(this)" onkeypress="return isNumberKey(event)"> 
                                            </p>
                                        </li>
                                        <li>Prezzo 
                                            <p>
                                                <input class="form-control" type="number" min="0" step="1" placeholder="Da..." id="prezzoDa" onchange="impostaMinWrapper(this)" onkeypress="return isNumberKey(event)">
                                                <input class="form-control" type="number" min="0" step="1" placeholder="A..." id="prezzoA" onchange="impostaMaxWrapper(this)" onkeypress="return isNumberKey(event)">
                                            </p>
                                        </li>
                                        <li>Recensione
                                            <p>
                                                <input type="radio" value="all" name="filtro" checked="checked" onclick="impostaRecensione('all')"> tutte 
                                                <input type="radio" value="5stelle" name="filtro" onclick="impostaRecensione('5')"> 5 stelle 
                                                <input type="radio" value="4stelle" name="filtro" onclick="impostaRecensione('4')"> 4 stelle 
                                                <input type="radio" value="3stelle" name="filtro" onclick="impostaRecensione('3')"> 3 stelle 
                                                <input type="radio" value="2stelle" name="filtro" onclick="impostaRecensione('2')"> 2 stelle 
                                                <input type="radio" value="1stella" name="filtro" onclick="impostaRecensione('1')"> 1 stella 
                                            </p>
                                        </li>
                                    </ul>
                                </div>
                                <div class="col-sm-6 col-lg-6">
                                    <h3 class="alignCenter">Categorie</h3>
                                    <hr>
                                    <ul class="no_dots"> 
                                        <li><input type="radio" value="product" id="product" name="categoria" checked="checked" onclick="RadioSwitch('product')"> Oggetto</li>
                                        <li><input type="radio" value="seller" id="seller" name="categoria" onclick="RadioSwitch('seller')"> Venditore</li>
                                        <li><input type="radio" value="category" id="category" name="categoria" onclick="RadioSwitch('category')"> Categoria</li>
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
                                                        <input class="form-control" type="number" min="0" step="1" placeholder="KM Max" name="distanzaMax" onchange="impostaDistanzaWrapper(this)" onkeypress="return isNumberKey(event)"> 
                                                    </p>
                                                </li>
                                                <li>Prezzo 
                                                    <p>
                                                        <input class="form-control" type="number" min="0" step="1" placeholder="Da..." id="prezzoDa" onchange="impostaMinWrapper(this)" onkeypress="return isNumberKey(event)">
                                                        <input class="form-control" type="number" min="0" step="1" placeholder="A..." id="prezzoA" onchange="impostaMaxWrapper(this)" onkeypress="return isNumberKey(event)">
                                                    </p>
                                                </li>
                                                <li>Recensione
                                                    <p>
                                                        <input type="radio" value="all" name="filtro_xs" onclick="impostaRecensione('all')"> tutte 
                                                        <input type="radio" value="5stelle" name="filtro_xs" onclick="impostaRecensione('5')"> 5 stelle 
                                                        <input type="radio" value="4stelle" name="filtro_xs" onclick="impostaRecensione('4')"> 4 stelle 
                                                        <input type="radio" value="3stelle" name="filtro_xs" onclick="impostaRecensione('3')"> 3 stelle 
                                                        <input type="radio" value="2stelle" name="filtro_xs" onclick="impostaRecensione('2')"> 2 stelle 
                                                        <input type="radio" value="1stella" name="filtro_xs" onclick="impostaRecensione('1')"> 1 stella 
                                                    </p>
                                                </li>
                                            </ul>
                                        </div>
                                        <div class="navbar-header col-xs-6">
                                            <a class="btn navbar-text dropdown-toggle" id="..." data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" >
                                                Scegli categoria <span class="caret"></span>
                                            </a>
                                            <ul class="dropdown-menu dropdown-menu-left col-xs-8 hidden-sm hidden-md hidden-lg"> <!-- ?????????? sull'ipad non sparisce -->
                                                <li><a href="#"><input type="radio" value="product" id="product_xs" name="categoria_xs" checked="checked" onclick="RadioSwitch('product')"> Oggetto</a></li>
                                                <li><a href="#"><input type="radio" value="seller" id="seller_xs" name="categoria_xs" onclick="RadioSwitch('seller')"> Venditore</a></li>
                                                <li><a href="#"><input type="radio" value="category" id="category_xs" name="categoria_xs" onclick="RadioSwitch('category')"> Categoria</a></li>
                                            </ul>
                                        </div>
                                    </div>
                                </div>
                            </nav>
                        </div>
                    </div>

                    <!-- CORPO pagina -->           
                    <!-- RIEPILOGO ORDINE -->
                    <div class="tmargin">
                        <h3>Riepilogo carrello</h3>
                        <div class="col-xs-12" id="zonaProdotti">
                            <!-- Prodotti di prova -->
                            <!--<div class="row">
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
                            </div>-->
                        </div>                                                                    
                    </div>

                    <!-- RIEPILOGO / inserisci nuovo INDIRIZZO -->
                    <div class="row col-xs-12 col-md-6 col-lg-6">
                        <div class="col-lg-12" >
                            <h3>Indirizzo di spedizione</h3>
                            <div class="row col-xs-12" >
                                <div class="form-group" id="IndirizzoForm" name="FormIndirizzo" >
                                    <input name="paese" id="paese" type="text" onchange="datiModificati('indirizzo')" class="form-control" placeholder="Paese (si può anche fare a meno)" aria-describedby="sizing-addon2">
                                    <input name="indirizzo" id="indirizzo" onchange="datiModificati('indirizzo')" type="text" class="form-control" placeholder="Indirizzo" aria-describedby="sizing-addon2">
                                    <input name="citta" id="citta" type="text" onchange="datiModificati('indirizzo')" class="form-control" placeholder="Città" aria-describedby="sizing-addon2">
                                    <input name="provincia" id="provincia" onchange="datiModificati('indirizzo')" type="text" class="form-control" placeholder="Provincia" aria-describedby="sizing-addon2">
                                    <input name="cap" id="cap" type="number" onchange="datiModificati('indirizzo')" class="form-control" placeholder="Codice postale" aria-describedby="sizing-addon2">

                                    <button class="btn btn-primary" onclick="checkDatiIndirizzo()">Conferma indirizzo</button>
                                </div> 
                            </div>

                        </div>
                    </div>    

                    <!-- RIEPILOGO / inserisci nuovi DATI CARTA CREDITO -->
                    <div class="row col-xs-12 col-md-6 col-lg-6" id="div_creditcard" >
                        <div class="col-lg-12">    
                            <h3>Carta di credito</h3>
                            <div class="row col-xs-12">
                                <input name="intestatario" id="intestatario" onchange="datiModificati('carta')" type="text" class="form-control" placeholder="Intestatario" aria-describedby="sizing-addon2">
                                <input name="numerocarta" id="numerocarta" onchange="datiModificati('carta')" type="number" class="form-control" placeholder="Numero carta" aria-describedby="sizing-addon2">

                                <div style="align: left">Data di scadenza</div>
                                <div>
                                    <div class="dropdown" style="display: inline-block">
                                        <select name="mesescadenza" id="mesescadenza" onchange="datiModificati('carta')" class="btn btn-default dropdown-toggle" type="button" >
                                            <%
                                                  String codice = "";
                                                  for (int i = 1; i <= 12; i++)
                                                  {
                                                      codice += "<option value=\""+i+"\"><li>"+i+"</li></option>";
                                                  }
                                            %>
                                            <%= codice %>
                                        </select>
                                    </div>
                                    <div class="dropdown" style="display: inline-block;align: rigth ">

                                        <select name="annoscadenza" id="annoscadenza" onchange="datiModificati('carta')"  class="btn btn-default dropdown-toggle" type="button" >
                                            <%
                                                codice = "";
                                                int year = new java.util.Date().getYear() + 1900 ;
                                                for (int i = year; i <= year + 20; i++)
                                                {
                                                    codice += "<option value=\""+i+"\"><li>"+i+"</li></option>";
                                                }
                                            %>
                                            <%= codice %>

                                        </select>
                                    </div>
                                </div>

                                <button class="btn btn-primary" onclick="checkDatiCarta()">Conferma indirizzo</button>
                            </div>
                        </div>
                    </div>


                    <form action="ServletConfirmOrder" method="POST" >
                        <div class="row col-xs-12 alignCenter">
                            <h3>Seleziona la modalità di acquisto:</h3>
                            <button id="spedizione" class="btn btn-default" onclick="checkModalita('spedizione')">Spedizione</button>
                            <button id="ritiro" class="btn btn-default" onclick="checkModalita('ritiro')">Ritira in negozio</button>
                            <input type="text" name="modalita" id="txtmodalita" style="visibility: hidden; width: 0px; height: 0px" >
                        </div> 

                        <div class="row col-xs-12 alignCenter" style="margin-top: 10px" >
                            <!-- TO DO: finche l'utente non inserisce i dati richiesti, non viene sbloccato il button.
                                Se i dati sono già presenti perché vengono caricati dalla servlet, il btn è attivo
                                Se l'utente modifica i dati, devo controllare che siano ancora validi prima di lasciargli completare l'ordine -->
                            <button type="submit" id="btnCompletaAcquisto" onclick="completaOrdine('ok')" class="btn btn-primary" disabled="true">Completa l'acquisto</button>

                        </div>   
                    </form>
                </div> 

                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer -->
                <footer style="background-color: #dddddd" class="tmargin">
                    <div class="row">
                        <div class="col-xs-8 col-sm-4"><h5><b>Pagine</b></h5>
                            <p><a href="index.jsp"><span class="glyphicon glyphicon-menu-right"></span> Home</a></p>
                            <p><a href="searchPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Cerca prodotto</a></p> 
                            <p><a href="....."><span class="glyphicon glyphicon-menu-right"></span> Carrello</a></p> 
                            <!-- UTENTE SE "REGISTRATO" -> porta alla pag. ALTRIM. passa per la login -->
                            <%
                                if(userType.equals("0")) // registrato
                                {
                            %>
                            <p><a href="userPage.jsp?v=Profile#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                            <p><a href="ServletMyOrders"><span class="glyphicon glyphicon-menu-right"></span> Miei ordini</a></p>
                            <p><a href="userPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Rimborso / Anomalia</a></p>
                            <p><a href="userPage.jsp?v=CreateShop#createshop"><span class="glyphicon glyphicon-menu-right"></span> Diventa venditore</a></p>
                            <!-- NON SO SE SERVE. In teoria si. SE si va aggiunto anche nei menu a tendina -->
                            <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>

                            <%  }
                                else if(userType.equals("1")) // venditore
                                {  %>
                            <!-- UTENTE SE "VENDITORE" -> porta alla pag. ALTRIM. passa per la login -->
                            <p><a href="userPage.jsp?v=Profile#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                            <p><a href="ServletMyOrders"><span class="glyphicon glyphicon-menu-right"></span> Miei ordini</a></p>
                            <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>
                            <p><a href="userPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Negozio</a></p>
                            <p><a href="userPage.jsp?v=SellNewProduct#sellNewProduct"><span class="glyphicon glyphicon-menu-right"></span> Vendi Prodotto</a></p>
                            <p><a href="userPage.jsp?v=GestisciProdotti#gestisciProdotti"><span class="glyphicon glyphicon-menu-right"></span> Gestisci prodotti</a></p>
                            <%  }
                                else if(userType.equals("2")) // admin
                                {  %> 
                            <p><a href="userPage.jsp?v=Profile#profilo"><span class="glyphicon glyphicon-menu-right"></span> Profilo</a></p>
                            <p><a href="ServletMyOrders"><span class="glyphicon glyphicon-menu-right"></span> Miei ordini</a></p>
                            <p><a href="userPage.jsp?v=Notifiche&notificationId=tutte#notifiche"><span class="glyphicon glyphicon-menu-right"></span> Notifiche</a></p>
                            <%  }
                                else // non loggato
                                {  %>    
                            <p><a href="loginPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Accedi</a></p>
                            <p><a href="loginPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Registrati</a></p>
                            <%  }  %>        
                        </div>
                        <div class="hidden-xs col-sm-4"><h5><b>Categorie</b></h5>
                            <p><a href="index.jsp"><span class="glyphicon glyphicon-menu-right"></span> Oggetto</a></p>
                            <p><a href="searchPage.jsp"><span class="glyphicon glyphicon-menu-right"></span> Venditore</a></p>
                        </div>

                        <div class="col-xs-4"><h5><b>Logout</b></h5>
                            <p><a href="ServletLogout"><span class="glyphicon glyphicon-menu-right"></span> ESCI</a></p>
                        </div>
                    </div>
                    <div class="row col-xs-12">
                        <p>&copy; Amazoff 2017 - info@amazoff.com - via di Amazoff 69, Trento, Italia</p>
                    </div>
                </footer>

            </div>

            <!-- barra bianca a dx -->
            <div class="hidden-xs col-lg-1"></div>                                    
        </div>



        <script>
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
                $('[data-toggle="popover"]').popover({
                    container: 'body'
                });
            });


            // inserisco i dati dell'utente e della carta, nella pagina
            AggiungiDatiUtente();
            AggiungiDatiMetodoPagamento();
            AggiungiProdotti(cartReceived);

            // inizializzazione del bottone per l'acquisto
            enabledBtnAcquista("inizializzazione");

            // inizializzazione delle notifiche e del suo button.
            $('[data-toggle="popover"]').attr('data-content', inserisciNotifiche());

        </script>
    </body>
</html>
