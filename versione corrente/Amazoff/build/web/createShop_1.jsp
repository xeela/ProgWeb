<%-- 
    Document   : index
    Created on : 19-set-2017, 10.56.58
    Author     : Davide
--%>

<%@page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <script type="text/javascript">
        function show_hide_pass(txtID)
            {
                // ottendo il type dell'oggetto
                var tipo = $("#"+txtID).attr('type')
                
                if(tipo === "password") {
                    $("#"+txtID).prop('type', 'text');
                    // cambio l'icona presente sul bottone e il suo title
                    $("#btn"+txtID).prop('title', 'Nascondi password');
                    $("#span"+txtID).prop('class', 'glyphicon glyphicon-eye-close');
                }
                else {
                    $("#"+txtID).prop('type', 'password');
                    // cambio l'icona presente sul bottone e il suo title
                    $("#btn"+txtID).prop('title', 'Mostra password');
                    $("#span"+txtID).prop('class', 'glyphicon glyphicon-eye-open');
                }
                
                console.log($("#"+txtID).attr('type'));
            }
    </script>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDofgdH-2Rk2JWl1U_ZWs-yi2gq_U25txY&callback=initMap"></script> 
    <script type="text/javascript">
        var geocoder = new google.maps.Geocoder();
        var latLng = new google.maps.LatLng(41.9, 12.5);
        function geocodePosition(pos) {
          geocoder.geocode({
            latLng: pos
          }, function(responses) {
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
        function sendCoordinates(){
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
          google.maps.event.addListener(marker, 'dragstart', function() {
            updateMarkerAddress('Dragging...');
          });

          google.maps.event.addListener(marker, 'drag', function() {
            updateMarkerStatus('Dragging...');
            updateMarkerPosition(marker.getPosition());
          });

          google.maps.event.addListener(marker, 'dragend', function() {
            updateMarkerStatus('Drag ended');
            geocodePosition(marker.getPosition());
          });
          //add listener that gets triggered when the form submits
          
          
        }

        // Onload handler to fire off the app.
        google.maps.event.addDomListener(window, 'load', initialize);
    </script>
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
        <style>
            #mapCanvas {
              width: 500px;
              height: 400px;
              float: left;
            }
            #infoPanel {
              float: left;
              margin-left: 10px;
            }
            #infoPanel div {
              margin-bottom: 5px;
            }
        </style>
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
                                <div class="dropdownUtente col-lg-7" >
                                    <div class="btn-group">
                                        <a href="profilePage.jsp" class="btn btn-default" type="button" id="btnAccediRegistrati" >
                                            <% 
                                                String userType = "";
                                                try {
                                                    String user = (session.getAttribute("user")).toString();
                                                    userType = (session.getAttribute("categoria_user")).toString();
                                            %>
                                            <%= user %>
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
                
                <!--<div class='tmargin'>
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
                </div>-->
                                        
                                        
                                        
                                        
                                        
                <!-- sezione modifica dei dati -->
               <div>
                    
                    <h1>Dati Negozio</h1>
                    <FORM id="myform" onsubmit="sendCoordinates()" ENCTYPE='multipart/form-data' method='GET' action='ServletEditUser'>
                        <p>Nome</p>  <input type="text" name="nome" placeholder="Nome"/>
                        <br></br>
                        <p>Descrizione</p>  <input type="text" name="descrizione" placeholder="Descrizione negozio"/>
                        <br></br>
                        <p>Website</p> <input type="url" name="website" placeholder="URL"/>
                        <br/>
                        
                        <br/>
                        <div id="mapCanvas"></div>
                        <div id="infoPanel">
                          <b>Marker status:</b>
                          <div id="markerStatus"><i>Click and drag the marker.</i></div>
                          <b>Current position:</b>
                          <div id="info"></div>
                          <b>Closest matching address:</b>
                          <div id="address"></div>
                        </div>
                        <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/> <!--soluzione temporanea, forse :> -->
                        <!--<input type="text" name="coordinate" hidden="false" id="info"/>-->
                        
                        <input type="hidden" name="coordinate" id="info2"></input>
                        <INPUT TYPE='submit' VALUE='Crea Negozio' />
                        
                    </FORM>
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
