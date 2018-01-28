<%-- 
    Document   : userPage
    Created on : 20-set-2017, 18.30.25
    Authors     : Gianluca Pasqua - Francesco Bruschetti
--%>

<%@page import="com.amazoff.classes.Errors"%>
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
        
        <!-- <script type="text/javascript" src="js/jquery-1.9.1.min.js"></script> -->
        <script type="text/javascript" src="js/jquery.autocomplete.min.js"></script>
        <script type="text/javascript" src="js/search-autocomplete.js"></script>
        <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDofgdH-2Rk2JWl1U_ZWs-yi2gq_U25txY&callback=initMap"></script> 
        <script type="text/javascript" src="js/parametri-ricerca.js"></script>
        <script type="text/javascript" src="js/sjcl.js" ></script>
        <script src="js/popper.js"></script>
        <script src="js/popper-utils.js"></script>
        
        <link rel="stylesheet" href="css/amazoffStyle.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />

        <title>Amazoff</title>

        <!-- script gestione sezione "PROFILO" -->
        <script type="text/javascript">
            var condizioniAccettate = false;

            function MostraErrore(text)
            {
                document.getElementById("alertRegistrati").innerHTML = "<strong>Errore!</strong> " + text;
                document.getElementById("alertRegistrati").style.visibility = "visible";

                console.log(text);
            }

            function HashPasswordRegister()
            {
                var mail = $("#email").val();
                var name = $("#nameRegister").val();
                var surname = $("#surnameRegister").val();
                var user = $("#username").val();
                console.log(user);
                var oldpwd = $("#oldpwd").val();
                var newpwd = $("#newpwd").val();
                var pwdc = $("#newpwdconfirm").val();
                //Controllo se le password sono valide, lunghezze dei campi etc
                if (mail.length < 6 || !mail.includes("@"))
                {
                    MostraErrore("Indizizzo e-Mail non valido");
                    return false;
                } else if (name.length < 2)
                {
                    MostraErrore("Il nome deve essere di almeno 2 caratteri");
                    return false;
                } else if (surname.length < 2)
                {
                    MostraErrore("Il cognome deve essere di almeno 2 caratteri");
                    return false;
                } else if (user.length < 6)
                {
                    MostraErrore("L'username deve essere di almeno 6 caratteri");
                    return false;
                } else if (newpwd.length < 8)
                {
                    MostraErrore("La password deve essere di almeno 8 caratteri");
                    return false;
                } else if (newpwd != pwdc)
                {
                    console.log(oldpwd);
                    console.log(newpwd);
                    MostraErrore("Le password non coincidono");
                    return false;
                } else
                {
                    console.log($('#newpwd').val());
                    console.log("password ok");
                    //$("#progressBar").css("display", "block");
                    var newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash($('#newpwd').val()));
                    for (var i = 0; i < 10000; i++)
                        newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash(newPwd));
                    //alert(newPwd);
                    document.RegisterForm.hashedPassword.value = newPwd;
                    document.RegisterForm.newpwd.value = "";

                    var oldPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash($('#oldpwd').val()));
                    for (var i = 0; i < 10000; i++)
                        oldPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash(oldPwd));
                    //alert(newPwd);
                    document.RegisterForm.oldhashedPassword.value = oldPwd;
                    document.RegisterForm.oldpwd.value = "";


                    return true;
                }
                return false;
            }

            function HashPasswordLogin()
            {
                //$("#progressBar").css("display", "block");
                var newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash($('#pwdLogin').val()));
                for (var i = 0; i < 10000; i++)
                    newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash(newPwd));
                //alert(newPwd);
                document.LoginForm.hashedPassword.value = newPwd;
                document.LoginForm.password.value = "";
                return true;
            }

            function show_hide_pass(txtID)
            {
                // ottendo il type dell'oggetto
                var tipo = $("#" + txtID).attr('type')

                if (tipo === "password") {
                    $("#" + txtID).prop('type', 'text');
                    // cambio l'icona presente sul bottone e il suo title
                    $("#btn" + txtID).prop('title', 'Nascondi password');
                    $("#span" + txtID).prop('class', 'glyphicon glyphicon-eye-close');
                } else {
                    $("#" + txtID).prop('type', 'password');
                    // cambio l'icona presente sul bottone e il suo title
                    $("#btn" + txtID).prop('title', 'Mostra password');
                    $("#span" + txtID).prop('class', 'glyphicon glyphicon-eye-open');
                }

                console.log($("#" + txtID).attr('type'));
            }

            // quando l'utente clicca sulla check box delle condizioni, accedda di averle lette
            function statoTerminiCondizioni()
            {
                condizioniAccettate = true;
                document.getElementById("cbCondizioni").checked = true;
                document.getElementById("cbCondizioni").disabled = true;
                document.getElementById("btnRegistrati").disabled = false;
            }

            // funzione che controlla se la email inserita nel popup di reset password ha le dimensioni corrette
            function checkResetEmail(mail)
            {
                var mail = document.getElementById("inputEmail").value;
                if (mail.length < 6 || !mail.includes("@"))
                {      
                    document.getElementById("alertResetPassword").style.visibility = "visible";
                    return false;
                } else {
                    // chiudo la modal
                    $('#modalPasswordReset').modal('hide');
                    return true;
                }
            }
        </script>

        <!-- script gestione sezione "DIVENTA VENDITORE" -->
        <script>
            function show_hide_pass(txtID)
            {
                // ottendo il type dell'oggetto
                var tipo = $("#" + txtID).attr('type')

                if (tipo === "password") {
                    $("#" + txtID).prop('type', 'text');
                    // cambio l'icona presente sul bottone e il suo title
                    $("#btn" + txtID).prop('title', 'Nascondi password');
                    $("#span" + txtID).prop('class', 'glyphicon glyphicon-eye-close');
                } else {
                    $("#" + txtID).prop('type', 'password');
                    // cambio l'icona presente sul bottone e il suo title
                    $("#btn" + txtID).prop('title', 'Mostra password');
                    $("#span" + txtID).prop('class', 'glyphicon glyphicon-eye-open');
                }

                console.log($("#" + txtID).attr('type'));
            }

            var geocoder = new google.maps.Geocoder();
            var latLng = new google.maps.LatLng(41.9, 12.5);
            function geocodePosition(pos) {
                geocoder.geocode({
                    latLng: pos
                }, function (responses) {
                    if (responses && responses.length > 0) {
                        updateMarkerAddress(responses[0].formatted_address);
                    } else {
                        updateMarkerAddress('Cannot determine address at this location.');
                    }
                });
            }

            function updateMarkerStatus(str) {
            }

            function updateMarkerPosition(latLng) {

                document.getElementById('info2').innerHTML = [
                    latLng.lat(),
                    latLng.lng()
                ].join(';');
                console.log(document.getElementById('info2').innerHTML);
            }

            function updateMarkerAddress(str) {
               
            }
            //aggiorna le coordinate inserite dall'utente
            function sendCoordinates() {
                var coordinatesshop = document.getElementById('info').innerHTML;
                //alert(coordinatesshop);
                document.getElementById('info2').innerHTML = coordinatesshop;
                //alert(document.getElementById('info2').innerHTML);

            }
            function initialize() {
                latLng = new google.maps.LatLng(41.9, 12.5);
                var map = new google.maps.Map(document.getElementById('mapCanvas'), {
                    zoom: 5,
                    center: latLng,
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                });
                var marker = new google.maps.Marker({
                    position: latLng,
                    title: 'Point A',
                    map: map,
                    draggable: true
                });

                // Update current position info.
                updateMarkerPosition(latLng);
                geocodePosition(latLng);

                // Add dragging event listeners.
                google.maps.event.addListener(marker, 'dragstart', function () {
                    updateMarkerAddress('Dragging...');
                });

                google.maps.event.addListener(marker, 'drag', function () {
                    updateMarkerStatus('Dragging...');
                    updateMarkerPosition(marker.getPosition());
                });

                google.maps.event.addListener(marker, 'dragend', function () {
                    updateMarkerStatus('Drag ended');
                    geocodePosition(marker.getPosition());
                });
                //add listener that gets triggered when the form submits


            }

            // Onload handler to fire off the app.
            google.maps.event.addDomListener(window, 'load', initialize);
            //controlla che i dati inseriti per la vendita di un prodotto siano correttamente inseriti
            function checkProductData() {
                if (document.getElementById("prname").value !== "" && document.getElementById("prname").value !== undefined &&
                        document.getElementById("prdesc").value !== "" && document.getElementById("prname").value !== undefined &&
                        document.getElementById("prprice").value !== "" && document.getElementById("prname").value !== undefined &&
                        !isNaN(parseFloat(document.getElementById("prprice").value)))

                {
                    return true;
                }
                return false;
            }
        </script>    

        <!-- script gestione sezione "DATI NEGOZIO" -->
    </head>
    <body class="bodyStyle" onload="Autocomplete('product');
            document.getElementById('btnVendi').addEventListener('click', checkProductData, false);">

        <div class="container-fluid tmargin">


            <!-- barra bianca a sx -->
            <div class="hidden-xs col-lg-1"></div>

            <div class="col-xs-12 col-lg-10">

                <div class="row" > <!-- style="position: fixed; z-index: 999;" -->
                    <!-- barra con: login/registrati, cerca, carrello -->
                    <div class="logo col-xs-12 col-lg-1">
                        <div class="row">
                            <div class="col-xs-5 col-lg-12" >
                                <a href="index.jsp">
                                    <img class="logo2" src="images/logo/logo.png" alt="Amazoff"/>
                                </a>
                            </div>
                            <div class="col-xs-7 hidden-lg" > 
                                <div class="col-xs-3 hidden-lg iconSize imgCenter" > 
                                    <a class="dropdown" href="userPage.jsp" id="iconAccediRegistrati">
                                        <spam class="glyphicon glyphicon-user"> 
                                            <%
                                                try {
                                                    String user = (session.getAttribute("user")).toString();

                                                } catch (Exception ex) {
                                            %>
                                            Accedi 
                                            <script>document.getElementById("iconAccediRegistrati").href = "loginPage.jsp";</script>

                                            <%
                                                }
                                            %>
                                        </spam>
                                    </a>
                                </div>
                                <div class="col-xs-3 hidden-lg iconSize imgCenter" >
                                    <a href="ServletShowCart">
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
                                            String userType = "";
                                            String fname = "", lname = "";
                                            try {
                                                String user = (session.getAttribute("user")).toString();
                                                userType = (session.getAttribute("categoria_user")).toString();
                                                fname = (session.getAttribute("fname")).toString();
                                                lname = (session.getAttribute("lname")).toString();
                                        %>
                                        <%= fname + " " + lname%>
                                        <%
                                        } catch (Exception ex) {
                                        %>
                                        Accedi / Registrati

                                        <script>document.getElementById("btnAccediRegistrati").href = "loginPage.jsp";</script>
                                        <%
                                            }
                                        %>
                                    </a>      

                                </div>
                            </div>

                            <div class="col-lg-4">
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
                                        <li><input type="radio" value="product" name="categoria" checked="checked" onclick="RadioSwitch('product')"> Oggetto</li>
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
                </div>                                    

                <!-- corpo della pagina con i dati dell'utente, negozio etc -->
                <div class='tmargin'>
                    <div class="page">
                        <ul class="list-group">
                            <div class="list-group-item"> 
                                <!-- gestione dati profilo, visibile a tutti -->
                                <div id="profilo" role="tablist" aria-multiselectable="true">
                                    Profilo 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseProfile" aria-expanded="true" 
                                       aria-controls="collapseProfile" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>
                                    <div id="collapseProfile" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-3"></div>
                                            <div class="col-lg-6">
                                                <h3 style="text-align: center">Aggiorna le tue credenziali:</h3>
                                                <form  style="text-align: center" class="form-group" id="RegisterForm" name="RegisterForm" action="ServletUpdateCredentials" method="POST" >

                                                    <div class="form-group">
                                                        <input id="email" type="text" name="email" class="form-control" value="<%if(session.getAttribute("email") != null){%><%= session.getAttribute("email")%><%} else {}%>" placeholder="<%if(session.getAttribute("email") != null){%> <%= session.getAttribute("email")%><% }else{%>Email<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="username" type="text" name="username" class="form-control" value="<%if(session.getAttribute("user") != null){%><%= session.getAttribute("user")%><%} else {}%>" placeholder="<%if(session.getAttribute("user") != null){%> <%= session.getAttribute("user")%><% }else{%>Username<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="nameRegister" type="text" name="name" class="form-control" value ="<%if(session.getAttribute("fname") != null){%><%= session.getAttribute("fname")%><%} else {} %>" placeholder="<%if(session.getAttribute("fname") != null){%> <%= session.getAttribute("fname")%><% }else{%>Nome<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="surnameRegister" type="text" name="surname" class="form-control" value ="<%if(session.getAttribute("lname") != null){%><%= session.getAttribute("lname")%><%} else {} %>" placeholder="<%if(session.getAttribute("lname") != null){%> <%= session.getAttribute("lname")%><% }else{%>Cognome<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group input-group">
                                                        <input id="oldpwd" type="password"  class="form-control" placeholder="Vecchia password" aria-describedby="sizing-addon2">
                                                        <span class="input-group-btn">
                                                            <a id="btnoldPassword" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('oldpwd')">
                                                                <span id="spanoldpassword" class="glyphicon glyphicon-eye-open"></span>
                                                            </a>
                                                        </span>
                                                    </div>
                                                    <div class="form-group input-group">
                                                        <input id="newpwd" type="password" name="newpwd" class="form-control" placeholder="Password" aria-describedby="sizing-addon2">
                                                        <span class="input-group-btn">
                                                            <a id="btnpwdRegister" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('newpwd')">
                                                                <span id="spanpwdRegister" class="glyphicon glyphicon-eye-open"></span>
                                                            </a>
                                                        </span>
                                                    </div>
                                                    <div class="form-group input-group">
                                                        <input id="newpwdconfirm" type="password" class="form-control" placeholder="Ripeti password" aria-describedby="sizing-addon2">
                                                        <input id="hashedPassword" type="hidden" name="hashedPassword" value="pigreco" />
                                                        <input id="oldhashedPassword" type="hidden" name="oldhashedPassword" value="pigreco" />
                                                        <span class="input-group-btn">
                                                            <a id="btnpwdRegisterConfirm" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('newpwdconfirm')">
                                                                <span id="spanpwdRegisterConfirm" class="glyphicon glyphicon-eye-open"></span>
                                                            </a>
                                                        </span>
                                                    </div>


                                                </form>
                                                <div class="form-group tmargin">
                                                    <button id="btnRegistrati" class="btn btn-default" onclick="if (HashPasswordRegister()) {
                                                                document.getElementById('RegisterForm').submit();
                                                            }" >Aggiorna dati</button>
                                                    <a href="index.jsp" type="button" class="btn btn-danger">Annulla</a>
                                                </div>

                                                <div class="alert alert-danger alert-dismissible" style="<% 
                                                            if(session.getAttribute("errorMessage") != Errors.resetError) { %> visibility: visible<%} else {%>visibility:hidden<%}%>" id="alertRegistrati" role="alert">

                                                    <!-- div che visualizza il messaggio di errore durante il login -->
                                                    <% 
                                                            if(session.getAttribute("errorMessage") != Errors.resetError) { %>   
                                                    <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                                    <strong>Errore!</strong> <%=session.getAttribute("errorMessage")%>
                                                    <% } %>

                                                </div>
                                                <%
                                                session.setAttribute("errorMessage", Errors.resetError);
                                                %>
                                            </div>
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            <%
                                if (userType.equals("0")) // registrato
                                { %>
                            <div id="ordini" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">                                     
                                    <a href="ServletMyOrders">
                                        Miei ordini
                                    </a>                                               
                                </div>
                            </div>
                            <div id="notifiche" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">
                                    Notifiche 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseNotifiche" aria-expanded="true" 
                                       aria-controls="collapseNotifiche" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>

                                    <div id="collapseNotifiche" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-2"></div>
                                            <div id="div_notifiche" class="col-lg-8">

                                            </div>    
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            
                            <div class="list-group-item">  
                                <div id="createshop" role="tablist" aria-multiselectable="true">
                                    Crea Negozio 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseCreateShop" aria-expanded="true" 
                                       aria-controls="collapseCreateShop" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>

                                    <div id="collapseCreateShop" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">

                                        <form id="myform"  ENCTYPE='multipart/form-data' method='GET' action='ServletRegisterShop'>
                                            <div class="row">
                                                <div class="col-sm-4 col-sm-offset-2">
                                                    <div class="row">
                                                        <h3 class="">Inserisci Dati Negozio</h3>
                                                    </div>

                                                    <div class="row">
                                                        <p></p>
                                                        <b>Nome</b>
                                                        <p><input type="text" name="nome" placeholder="..." class="col-lg-10"/></p>
                                                    </div>
                                                    <div class="row">
                                                        <p></p>
                                                        <b>Descrizione </b>
                                                        <p><input type="text" name="descrizione" placeholder="..." class="col-lg-10"/></p>
                                                    </div>
                                                    <div class="row">
                                                        <p></p>
                                                        <b>Website</b>
                                                        <p><input type="url" name="website" placeholder="URL" class="col-lg-10"/></p>
                                                    </div>
                                                    <div class="row">
                                                        <p></p>
                                                        <b>Giorni di apertura</b>
                                                        <div>
                                                            <input name="mon" type="checkbox" value="true"/> Lunedì <br/>
                                                            <input name="tue" type="checkbox" value="true"/> Martedì  <br/>
                                                            <input name="wed" type="checkbox" value="true"/> Mercoledì   <br/>
                                                            <input name="thu" type="checkbox" value="true"/> Giovedì   <br/>
                                                            <input name="fri" type="checkbox" value="true"/> Venerdì   <br/>
                                                            <input name="sat" type="checkbox" value="true"/> Sabato   <br/>
                                                            <input name="sun" type="checkbox" value="true"/> Domenica   <br/>

                                                        </div>
                                                        <p></p>
                                                    </div>
                                                    <div class="row">
                                                        <p><b>Città</b></p>
                                                        <input type="text" name="citta" placeholder="..." class="col-lg-10"/>
                                                    </div>
                                                    <div class="row"></div>
                                                    
                                                </div>   
                                                <div class="col-lg-6 col-md-6 col-sm-6  ">
                                                    <h3 class="alignLeft">Posizione Geografica</h3>
                                                    <div id="mapCanvas" class="col-sm-6 " style="max-width: 100%" ></div>
                                                   <!-- <div id="infoPanel" >
                                                      <b>Marker status:</b>
                                                       <div id="markerStatus"><i>Click and drag the marker.</i></div>
                                                       <b>Current position:</b>
                                                       <div  name="coordinate" id="info"></div>
                                                       <b>Closest matching address:</b>
                                                       <div id="address"></div>
                                                   </div>-->
                                                    <!--<input type="text" name="coordinate" hidden="false" id="info"/>-->
                                                    
                                                    <input type="hidden" name="coordinate" id="info2"></input>
                                                </div>
                                                <div class="row"></div>
                                            <INPUT TYPE='submit' VALUE='Crea Negozio' class="btn col-lg-4 col-lg-offset-3" />
                                         </div>
                                        <!--<input class="btn col-lg-4 col-lg-offset-3" type="button" value="Crea Negozio" onclick="sendCoordinates(); document.getElementById('myform').submit();"></button>-->
                                           

                                    </div>       
                                        </form>  
                                </div>
                            </div>
                            <%
                            } else if (userType.equals("1")) // venditore
                            { %>
                            <!--<a href="profilePage.jsp" class="list-group-item">
                              <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                              Profilo
                            </a> -->
                            <div id="ordini" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">                                     
                                    <a href="ServletMyOrders">
                                        Miei ordini
                                    </a>                                               
                                </div>
                            </div>
                            <div id="notifiche" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">
                                    Notifiche 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseNotifiche" aria-expanded="true" 
                                       aria-controls="collapseNotifiche" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>

                                    <div id="collapseNotifiche" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-2"></div>
                                            <div id="div_notifiche" class="col-lg-8">

                                            </div>    
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            <!--
                             <a href=".jsp" class="list-group-item">
                                 <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                 Negozio TO DO...
                             </a>
                            -->
                            <div class="list-group-item">  
                                <div id="negozio" role="tablist" aria-multiselectable="true">
                                    Dati Negozio 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseNegozio" aria-expanded="true" 
                                       aria-controls="collapseNegozio" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>
                                    <div id="collapseNegozio" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-3"></div>
                                            <div class="col-lg-6">
                                                <h3 style="text-align: center">Aggiorna i dati del tuo Business:</h3>
                                                <form  style="text-align: center" class="form-group" id="ShopForm" name="ShopForm" action="ServletUpdateBusiness" method="POST" >
                                                    <div class="row">
                                                    </div>
                                                    <div class="form-group">
                                                        <b>Nome del Negozio</b>
                                                        <input id="shop_website" type="text" name="shop_name" class="form-control" value="<%if(session.getAttribute("shop_name") != null){%><%= session.getAttribute("shop_name")%><%} else {}%>" placeholder="<%if(session.getAttribute("shop_name") != null){%> <%= session.getAttribute("shop_name")%><% }else{%>Nome negozio<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <b>Descrizione</b>
                                                        <input id="shop_description" type="text" name="shop_description" class="form-control" value ="<%if(session.getAttribute("shop_description") != null){%><%= session.getAttribute("shop_description")%><%} else {} %>" placeholder="<%if(session.getAttribute("shop_description") != null){%> <%= session.getAttribute("shop_description")%><% }else{%>Descrizione negozio<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <b>sito web</b>
                                                        <input id="shop_website" type="url" name="shop_website" class="form-control" value ="<%if(session.getAttribute("shop_website") != null){%><%= session.getAttribute("shop_website")%><%} else {} %>" placeholder="<%if(session.getAttribute("shop_website") != null){%> <%= session.getAttribute("shop_website")%><% }else{%>Website<%}%>" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <p></p>
                                                        <b>Giorni di apertura</b>
                                                        <div>
                                                            <input name="mon" type="checkbox" value="true"/> Lunedì 
                                                            <input name="tue" type="checkbox" value="true"/> Martedì
                                                            <input name="wed" type="checkbox" value="true"/> Mercoledì 
                                                            <input name="thu" type="checkbox" value="true"/> Giovedì  
                                                            <input name="fri" type="checkbox" value="true"/> Venerdì   
                                                            <input name="sat" type="checkbox" value="true"/> Sabato   
                                                            <input name="sun" type="checkbox" value="true"/> Domenica   

                                                        </div>
                                                    </div>
                                                </form>
                                                <div class="form-group tmargin">
                                                    <button id="btnUpdateShop" class="btn btn-default" onclick="document.getElementById('ShopForm').submit();" >Aggiorna dati</button>
                                                    <a href="index.jsp" type="button" class="btn btn-danger">Annulla</a>
                                                </div>

                                                <%
                                                session.setAttribute("errorMessage", Errors.resetError);
                                                %>
                                            </div>
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            <div id="sellNewProduct" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">
                                    Vendi prodotto 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseSellNewProduct" aria-expanded="true" 
                                       aria-controls="collapseSellProduct" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>

                                    <div id="collapseSellNewProduct" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-3"></div>
                                            <div class="col-lg-6">
                                                <h3 class="alignCenter">Cosa vuoi vendere?</h3>
                                                <form id="vendiForm" ENCTYPE='multipart/form-data' method='POST' action='ServletAddProduct' >
                                                    <div class="form-group">
                                                        <input id="prname" name="nome" type="text" class="form-control" placeholder="Nome Prodotto" aria-describedby="basic-addon1"></input>
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="prdesc" name="descrizione" type="text" class="form-control" placeholder="Descrizione" aria-describedby="basic-addon1"></input>
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="prprice" name="prezzo" type="text" class="form-control" placeholder="Prezzo" aria-describedby="basic-addon1"></input>
                                                    </div>
                                                    <div class="btn-group">
                                                        <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">Categoria<span class="caret"></span></button>
                                                        <ul class="dropdown-menu scrollable-menu" role="menu" name ="categoria">
                                                            <li><a href="#" value="0" selected="selected"> Abbigliamento</a></li>
                                                            <li><a href="#" value="1"> Alimentari</a></li>
                                                            <li><a href="#" value="2"> Auto</a></li>
                                                            <li><a href="#" value="3"> Bellezza</a></li>
                                                            <li><a href="#" value="4"> Cancelleria</a></li>
                                                            <li><a href="#" value="5"> Casa</a></li>
                                                            <li><a href="#" value="6"> CD</a></li>
                                                            <li><a href="#" value="7"> Elettronica</a></li>
                                                            <li><a href="#" value="8"> Fai Da Te</a></li>
                                                            <li><a href="#" value="9"> Film</a></li>
                                                            <li><a href="#" value="10"> Giochi</a></li>
                                                            <li><a href="#" value="11"> Gioielli</a></li>
                                                            <li><a href="#" value="12"> Illuminazione</a></li>
                                                            <li><a href="#" value="13"> Informatica</a></li>
                                                            <li><a href="#" value="14"> Libri</a></li>
                                                            <li><a href="#" value="15"> Musica</a></li>
                                                            <li><a href="#" value="16"> Orologi</a></li>
                                                            <li><a href="#" value="17"> Salute</a></li>
                                                            <li><a href="#" value="18"> Sport</a></li>
                                                            <li><a href="#" value="19"> Valigie</a></li>
                                                            <li><a href="#" value="20"> Videogiochi</a></li>
                                                        </ul>
                                                    </div>
                                                    <p>Tipo di consegna:</p>
                                                    <div class="form-group">
                                                        <div class="radio">
                                                            <label><input value="spedizione" type="radio" name="consegna" checked>Spedizione standard</label>

                                                        </div>
                                                        <div class="radio">
                                                            <label><input value="ritiro" type="radio" name="consegna" >Ritiro in sede</label>
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <input TYPE='file' NAME='productPic' class="btn btn-default form-control" aria-describedby="basic-addon1" accept=".jpg, .jpeg, .png, .gif">
                                                        <!-- [5+] Multiple file:<input multiple TYPE='file' NAME='productPic3' class="btn btn-default form-control" aria-describedby="basic-addon1"> -->
                                                    </div>

                                                    <div class="form-group">
                                                        <!--<input TYPE='submit' hidden="true" NAME='productPic1' VALUE='Aggiungi prodotto' class="btn btn-default" aria-describedby="basic-addon1">
                                                        --></div>
                                                </form>
                                                <div class="form-group tmargin">
                                                    <button id="btnVendi" type='button' class="btn btn-default" onclick="if (checkProductData()) {
                                                                document.getElementById('vendiForm').submit();
                                                            }">Aggiungi Prodotto</button>
                                                    <a href="index.jsp" type="button" class="btn btn-danger">Annulla</a>
                                                </div>
                                            </div>    
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            <%
                            } else if (userType.equals("2")) //admin
                            { %>
                            <div id="ordini" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">                                     
                                    <a href="ServletMyOrders">
                                        Miei ordini
                                    </a>                                               
                                </div>
                            </div>
                            <div id="anomalie" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">                                     
                                    <a href="ServletRecuperaAnomalie">
                                        Gestione Anomalie
                                    </a>                                               
                                </div>
                            </div>
                            <div id="notifiche" class="list-group-item">
                                <div role="tablist" aria-multiselectable="true">
                                    Notifiche 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseNotifiche" aria-expanded="true" 
                                       aria-controls="collapseNotifiche" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>

                                    <div id="collapseNotifiche" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-2"></div>
                                            <div id="div_notifiche" class="col-lg-8">

                                            </div>    
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            <% } %>

                            <a id="esci" href="/Amazoff/ServletLogout" class="list-group-item active">
                                <span class="badge"><span class='glyphicon glyphicon-log-out'></span></span>
                                Esci
                            </a>

                        </ul>   
                    </div>
                </div>

                <!-- back to top button -->
                <button onclick="topFunction()" id="btnTop" title="Go to top"><span class="glyphicon glyphicon-arrow-up"> Top</span></button>

                <!-- footer --
                <footer style="background-color: red">
                    <p>&copy; Company 2017</p>
                </footer> -->

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

            function inserisciNotifiche()
            {
                var toAdd = "";
                var idNotifica;

                for (var i = jsonNotifiche.notifications.length - 1; i >= 0; i--)
                {
                    idNotifica = jsonNotifiche.notifications[i].id;
                    toAdd += "<div id=\"notifica" + idNotifica + "\" class=\"panel-group\" role=\"tablist\" aria-multiselectable=\"true\">";
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
                        toAdd += " <b style=\"color: red\">NEW!</b> </p>";
                    } else {
                        toAdd += "</p>";

                    }
                    toAdd += "<a href=\"" + jsonNotifiche.notifications[i].link + "&notificationId=" + idNotifica + "\">";
                    toAdd += jsonNotifiche.notifications[i].description;
                    toAdd += "</a>";
                    toAdd += "      <div id=\"collapse" + idNotifica + "\" class=\"panel-collapse collapse out\" role=\"tabpanel\" aria-labelledby=\"heading" + idNotifica + "\">";
                    toAdd += jsonNotifiche.notifications[i].description;
                    toAdd += "      </div>";
                    toAdd += "      <br>";
                    toAdd += "      <a data-toggle=\"collapse\" data-parent=\"#accordion\"";
                    toAdd += "         href=\"#collapse" + idNotifica + "\" aria-expanded=\"true\" aria-controls=\"collapse" + idNotifica + "\">";
                    toAdd += "         <span class=\"glyphicon glyphicon-option-horizontal\"></span>";
                    toAdd += "      </a>";
                    toAdd += " </div>";
                }

                return toAdd;
            }

            <% // se viene passato alla pagina il valore a=active, rende visibile la riga relativa al valore v
                // --> dice sempre null 
                if (request.getParameter("v") != null) {
            %>
            $('#collapse<%=request.getParameter("v")%>').addClass('in');
            <%
                }
            %>

            var idNotifica, jsonNotifiche;
            jsonNotifiche = ${jsonNotifiche};
            <% if (request.getParameter("v") != null && request.getParameter("notificationId") != null) {%>
            jsonNotifiche = ${jsonNotifiche}; // da errore se l'utente non è loggato, perche non ha delle notifiche associate
            //console.log(jsonNotifiche);
            $("#div_notifiche").html(inserisciNotifiche());
            idNotifica = <%=request.getParameter("notificationId")%>;
            <% } else { %>
            if (jsonNotifiche == undefined)
            {
                $("#div_notifiche").html("Nessuna notifica trovata.");
            }
            else
                $("#div_notifiche").html(inserisciNotifiche());

            <% } %>

            // chiamata ajax per settare la notifica cliccata come "LETTA"
            $.post('ServletAjaxNotifiche', {
                idNotification: idNotifica
            }, function (data) {

                console.log("ServletAjaxNotifiche " + data);

            }).fail(function () {
            });

        </script>
    </body>
</html>
