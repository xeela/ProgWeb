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
        <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDofgdH-2Rk2JWl1U_ZWs-yi2gq_U25txY&callback=initMap"></script> 


        <link rel="stylesheet" href="css/amazoffStyle.css">

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
                var mail = $("#mailRegister").val();
                var name = $("#nameRegister").val();
                var surname = $("#surnameRegister").val();
                var user = $("#usernameRegister").val();
                var pwd1 = $("#pwdRegister").val();
                var pwd2 = $("#pwdRegisterConfirm").val();

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
                } else if (pwd1.length < 8)
                {
                    MostraErrore("La password deve essere di almeno 8 caratteri");
                    return false;
                } else if (pwd1 != pwd2)
                {
                    MostraErrore("Le password non coincidono");
                    return false;
                } else
                {
                    //$("#progressBar").css("display", "block");
                    var newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash($('#pwdRegister').val()));
                    for (var i = 0; i < 10000; i++)
                        newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash(newPwd));
                    //alert(newPwd);
                    document.RegisterForm.hashedPassword.value = newPwd;
                    document.RegisterForm.password.value = "";
                    return true;
                }
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
                //OSSSSSS: oltre al controllo sulla lunghezza della email, andrebbe controllato, magari con ajax, se la password esiste nel db
                var mail = document.getElementById("inputEmail").value;
                if (mail.length < 6 || !mail.includes("@"))
                {
                    // chiama ajax che controlla se la email è presente nel db
                    //if(checkEmailExists(mail)) {          
                    document.getElementById("alertResetPassword").style.visibility = "visible";
                    //  return false;
                    // }
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
                document.getElementById('markerStatus').innerHTML = str;
            }

            function updateMarkerPosition(latLng) {

                document.getElementById('info').innerHTML = [
                    latLng.lat(),
                    latLng.lng()
                ].join(', ');
            }

            function updateMarkerAddress(str) {
                document.getElementById('address').innerHTML = str;
            }
            function sendCoordinates() {
                //    alert([
                //    latLng.lat(),
                //    latLng.lng()
                //  ].join(';'));
                document.getElementById('info2').value = [
                    latLng.lat(),
                    latLng.lng()
                ].join(';');
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
            
            function RadioSwitch(value){
                $("#categoriaRicerca").val(value);
            }
            
            function impostaRecensione(value){
                if($("#recensioneRicerca").length){
                    if(value == "all"){
                        $("#recensioneRicerca").remove();
                    } else{
                        $("#recensioneRicerca").val(value);
                    }
                } else if (value != 'all'){
                    $("#parametriRicerca").append('<input id="recensioneRicerca" name="recensioneRicerca" type="text" style="display:none;" value="">');
                    $("#recensioneRicerca").val(value);
                }
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

                                            } catch (Exception ex) {
                                        %>
                                <script>document.getElementById("iconAccediRegistrati").href = "loginPage.jsp";</script>
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

                                    <div role="tablist" aria-multiselectable="true">
                                        <a type="button" class="btn btn-default dropdown-toggle hidden-xs" data-toggle="collapse" data-parent="#accordion"
                                           href="#collapseFilter" aria-expanded="false "  aria-haspopup="true"
                                           aria-controls="collapseFilter" >
                                            <span class="glyphicon glyphicon-filter"></span>
                                        </a>
                                    </div>
                                </div>

                                <input id="txtCerca" name="txtCerca" type="text" class="form-control" aria-label="..." placeholder="Cosa vuoi cercare?">
                                <input id="categoriaRicerca" name="categoriaRicerca" type="text" style="display:none;" value="product">
                                
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
                                <a href="shopping-cartPage.jsp" type="button" class="btn btn-default btn-md">
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
                                                <input class="form-control" type="number" placeholder="KM Max" name="distanzaMax"> 
                                            </p>
                                        </li>
                                        <li>Prezzo 
                                            <p>
                                                <input class="form-control" type="number" placeholder="Da..." name="prezzoDa"> 
                                                <input class="form-control" type="number" placeholder="A..." name="prezzoA">
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
                                                        <input class="form-control" type="number" placeholder="KM Max" name="distanzaMax"> 
                                                    </p>
                                                </li>
                                                <li>Prezzo 
                                                    <p>
                                                        <input class="form-control"type="number" placeholder="Da..." name="prezzoDa"> 
                                                        <input class="form-control" type="number" placeholder="A..." name="prezzoA">
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

                <!-- tabella di 2 righe, con 3 colonne, che mostrano 6 prodotti -->
                <div class='tmargin'>
                    <div class="page">
                        <ul class="list-group">
                            <div class="list-group-item">  
                                <div id="profilo" role="tablist" aria-multiselectable="true">
                                    Profilo 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseProfile" aria-expanded="true" 
                                       aria-controls="collapseProfile" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>
                                    <div id="collapseProfilo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                                        <div class="row">
                                            <div class="col-lg-3"></div>
                                            <div class="col-lg-6">
                                                <h3 style="text-align: center">Aggiorna le tue credenziali:</h3>
                                                <form  style="text-align: center" class="form-group" id="RegisterForm" name="RegisterForm" action="ServletUpdateProfile" method="POST" onsubmit="return HashPasswordRegister();">

                                                    <div class="form-group">
                                                        <input id="mailRegister" type="text" name="email" class="form-control" placeholder="Email" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="usernameRegister" type="text" name="username" class="form-control" placeholder="Username" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group">
                                                        <input id="nameRegister" type="text" name="name" class="form-control" placeholder="Nome" aria-describedby="sizing-addon2">
                                                    </div class="form-group">
                                                    <div class="form-group">
                                                        <input id="surnameRegister" type="text" name="surname" class="form-control" placeholder="Cognome" aria-describedby="sizing-addon2">
                                                    </div>
                                                    <div class="form-group input-group">
                                                        <input id="oldpassword" type="password"  class="form-control" placeholder="Vecchia password" aria-describedby="sizing-addon2">
                                                        <span class="input-group-btn">
                                                            <a id="btnoldPassword" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('oldpassword')">
                                                                <span id="spanoldpassword" class="glyphicon glyphicon-eye-open"></span>
                                                            </a>
                                                        </span>
                                                    </div>
                                                    <div class="form-group input-group">
                                                        <input id="pwdRegister" type="password" name="password" class="form-control" placeholder="Password" aria-describedby="sizing-addon2">
                                                        <span class="input-group-btn">
                                                            <a id="btnpwdRegister" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('pwdRegister')">
                                                                <span id="spanpwdRegister" class="glyphicon glyphicon-eye-open"></span>
                                                            </a>
                                                        </span>
                                                    </div>
                                                    <div class="form-group input-group">
                                                        <input id="pwdRegisterConfirm" type="password" class="form-control" placeholder="Ripeti password" aria-describedby="sizing-addon2">
                                                        <input id="hashedPassword" type="hidden" name="hashedPassword" value="pigreco" />
                                                        <span class="input-group-btn">
                                                            <a id="btnpwdRegisterConfirm" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('pwdRegisterConfirm')">
                                                                <span id="spanpwdRegisterConfirm" class="glyphicon glyphicon-eye-open"></span>
                                                            </a>
                                                        </span>
                                                    </div>

                                                    <div class="form-group tmargin">
                                                        <button id="btnRegistrati" class="btn btn-default" >Aggiorna dati</button>
                                                        <a href="index.jsp" type="button" class="btn btn-danger">Annulla</a>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>                                                  
                                </div>
                            </div>
                            <%
                                if (userType.equals("0")) // registrato
                                { %>

                            <a href=".jsp" class="list-group-item">
                                <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                Rimborso / Anomalia
                            </a>

                            <div class="list-group-item">  
                                <div id="createshop" role="tablist" aria-multiselectable="true">
                                    Crea Negozio 
                                    <a data-toggle="collapse" data-parent="#accordion"
                                       href="#collapseCreateShop" aria-expanded="true" 
                                       aria-controls="collapseCreateShop" >
                                        <span class='glyphicon glyphicon-option-vertical'></span>
                                    </a>

                                    <div id="collapseCreateShop" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">

                                        <form id="myform" onsubmit="sendCoordinates()" ENCTYPE='multipart/form-data' method='GET' action='ServletEditUser'>
                                            <div class="row">
                                                <div class="col-sm-4 col-sm-offset-2">
                                                    <div class="row">
                                                            <h3 class="">Inserisci Dati Negozio</h3>
                                                    </div>
                                                    
                                                    <div class="row">
                                                        <p></p>
                                                        Nome
                                                        <p><input type="text" name="nome" placeholder="..." class="col-lg-10"/></p>
                                                    </div>
                                                    <div class="row">
                                                        <p></p>
                                                        Descrizione 
                                                        <p><input type="text" name="descrizione" placeholder="..." class="col-lg-10"/></p>
                                                    </div>
                                                    <div class="row">
                                                        <p></p>
                                                            Website
                                                            <p><input type="url" name="website" placeholder="URL" class="col-lg-10"/></p>
                                                    </div>
                                                    <div class="row">
                                                        <p></p>
                                                        Tipologia di consegna
                                                        <p><input name="spedizione" type="checkbox" value="true"/> Spedizione Standard                                                    <br/>
                                                            <input name="ritito" type="checkbox" value="true"/> Ritiro in negozio</p>
                                                    </div>
                                                    <INPUT TYPE='submit' VALUE='Crea Negozio' class="btn col-lg-4 col-lg-offset-3" />
                                                </div>   
                                                <div class="col-lg-6 col-md-6 col-sm-6  ">
                                                    <h3 class="alignLeft">Posizione Geografica</h3>
                                                    <div id="mapCanvas" class="col-sm-6 " style="max-width: 100%" ></div>
                                                    <!--<div id="infoPanel" >
                                                      <b>Marker status:</b>
                                                       <div id="markerStatus"><i>Click and drag the marker.</i></div>
                                                       <b>Current position:</b>
                                                       <div id="info"></div>
                                                       <b>Closest matching address:</b>
                                                       <div id="address"></div>
                                                   </div>-->
                                                    <!--<input type="text" name="coordinate" hidden="false" id="info"/>-->

                                                    <input type="hidden" name="coordinate" id="info2"></input>
                                                    
                                                </div>
                                            </div>
                                            <br/><br/><br/>
                                            
                                        </form>
                                    </div>         
                                </div>
                            </div>
                                    <%
                                    } else if (userType.equals("1")) // venditore
                                    { %>
                                    <!--<a href="profilePage.jsp" class="list-group-item">
                                      <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                      Profilo
                                    </a> -->
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
                                    <a href=".jsp" class="list-group-item">
                                        <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                        Negozio TO DO...
                                    </a>

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
                                                        <form ENCTYPE='multipart/form-data' method='POST' action='ServletAddProduct' >
                                                            <div class="form-group">
                                                                <input name="nome" type="text" class="form-control" placeholder="Nome Prodotto" aria-describedby="basic-addon1">
                                                            </div>
                                                            <div class="form-group">
                                                                <input name="descrizione" type="text" class="form-control" placeholder="Descrizione" aria-describedby="basic-addon1">
                                                            </div>
                                                            <div class="form-group">
                                                                <input name="prezzo" type="text" class="form-control" placeholder="Prezzo" aria-describedby="basic-addon1">
                                                            </div>

                                                            <div class="dropdown form-group">
                                                                <button  class="btn btn-default dropdown-toggle" type="button" id="ddCategoria" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true">
                                                                    Categoria <span class="caret"></span>
                                                                </button>
                                                                <ul class="dropdown-menu" name="categoria" aria-labelledby="ddCategoria">
                                                                    <li><a href="#" value="categoria1"> Categoria 1</a></li>
                                                                    <li><a href="#" value="categoria2"> Categoria 2</a></li>
                                                                    <li><a href="#" value="categoria3"> Categoria 3</a></li>
                                                                    <li role="separator" class="divider"></li>
                                                                    <li><a href="#">Separated link</a></li>
                                                                </ul>
                                                            </div> 
                                                            <div class="form-group">
                                                                <input TYPE='file' NAME='productPic' class="btn btn-default form-control" aria-describedby="basic-addon1">
                                                                Multiple file:<input multiple TYPE='file' NAME='productPic3' class="btn btn-default form-control" aria-describedby="basic-addon1">
                                                            </div>
                                                            <div class="form-group">
                                                                <input TYPE='submit' NAME='productPic1' VALUE='Aggiungi prodotto' class="btn btn-default" aria-describedby="basic-addon1">
                                                            </div>
                                                        </form>
                                                    </div>    
                                                </div>
                                            </div>                                                  
                                        </div>
                                    </div>


                                    <a id="gestisciProdotti" href=".jsp" class="list-group-item">
                                        <span class="badge"><span class='glyphicon glyphicon-chevron-right'></span></span>
                                        Gestisci prodotti
                                    </a>
                                    <%
                                    } else if (userType.equals("2")) //admin
                                    { %>
                                    <div class="list-group-item">
                                        <div role="tablist" aria-multiselectable="true">
                                            Notifiche TMP 2
                                            <a data-toggle="collapse" data-parent="#accordion"
                                               href="#collapseTwo" aria-expanded="true" 
                                               aria-controls="collapseTwo" >
                                                <span class='glyphicon glyphicon-option-vertical'></span>
                                            </a>

                                            <div id="collapseTwo" class="panel-collapse collapse out" role="tabpanel" aria-labelledby="headingOne">
                                                <div class="row">
                                                    <div class="col-lg-3"></div>
                                                    <div class="col-lg-6">
                                                        <h3 class="alignCenter">Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam eaque ipsa, quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt, explicabo. Nemo enim ipsam voluptatem, quia voluptas sit, aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos, qui ratione voluptatem sequi nesciunt, neque porro quisquam est, qui dolorem ipsum, quia dolor sit, amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt, ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit, qui in ea voluptate velit esse, quam nihil molestiae consequatur, vel illum, qui dolorem eum fugiat, quo voluptas nulla pariatur? [33] At vero eos et accusamus et iusto odio dignissimos ducimus, qui blanditiis praesentium voluptatum deleniti atque corrupti, quos dolores et quas molestias excepturi sint, obcaecati cupiditate non provident, similique sunt in culpa, qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio, cumque nihil impedit, quo minus id, quod maxime placeat, facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet, ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat. </h3>
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
                            toAdd += jsonNotifiche.notifications[i].description;
                            toAdd += "      <div id=\"collapse" + idNotifica + "\" class=\"panel-collapse collapse out\" role=\"tabpanel\" aria-labelledby=\"heading" + idNotifica + "\">";
                            toAdd += "tutto il messaggio. per ora non esiste un campo nel db in cui è salvato. E' solo presente una 'descrizione' = " + jsonNotifiche.notifications[i].description;
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

                    <% if (request.getParameter("v") != null && request.getParameter("notificationId") != null) {%>
                    var jsonNotifiche = ${jsonNotifiche}; // da errore se l'utente non è loggato, perche non ha delle notifiche associate
                    console.log(jsonNotifiche);
                    $("#div_notifiche").html(inserisciNotifiche());
                    var idNotifica = <%=request.getParameter("notificationId")%>;
                    <% }%>




                    // chiamata ajax per settare la notifica cliccata come "LETTA"
                    $.post('ServletAjaxNotifiche', {
                        idNotification: idNotifica
                    }, function (data) {

                        alert(data);

                    }).fail(function () {
                    });
                </script>
                </body>
                </html>
