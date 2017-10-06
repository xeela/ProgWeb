<%@page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Amazoff</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- *** senza questo, i col di bootstrap non funzionano correttamente *** -->
        <meta name="viewport" content="width=device-width, initial-scale=1"> 
        
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/sjcl.js" ></script>
        <link rel="stylesheet" href="css/amazoffStyle.css">
        
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
                if(mail.length < 6 || !mail.includes("@"))
                {
                    MostraErrore("Indizizzo e-Mail non valido");
                    return false;
                }
                else if(name.length < 2)
                {
                    MostraErrore("Il nome deve essere di almeno 2 caratteri");
                    return false;
                }
                else if(surname.length < 2)
                {
                    MostraErrore("Il cognome deve essere di almeno 2 caratteri");
                    return false;
                }
                else if(user.length < 6)
                {
                    MostraErrore("L'username deve essere di almeno 6 caratteri");
                    return false;
                }
                else if(pwd1.length < 8)
                {
                    MostraErrore("La password deve essere di almeno 8 caratteri");
                    return false;
                }
                else if(pwd1 != pwd2)
                {
                    MostraErrore("Le password non coincidono");
                    return false;
                }
                else
                {
                    //$("#progressBar").css("display", "block");
                    var newPwd = sjcl.codec.hex.fromBits( sjcl.hash.sha256.hash($('#pwdRegister').val()) );
                    for(var i = 0; i < 10000; i++)
                        newPwd = sjcl.codec.hex.fromBits( sjcl.hash.sha256.hash(newPwd) );
                    //alert(newPwd);
                    document.RegisterForm.hashedPassword.value = newPwd;
                    document.RegisterForm.password.value = "";
                    return true;
                }
            }

            function HashPasswordLogin()
            {
                //$("#progressBar").css("display", "block");
                var newPwd = sjcl.codec.hex.fromBits( sjcl.hash.sha256.hash($('#pwdLogin').val()) );
                for(var i = 0; i < 10000; i++)
                    newPwd = sjcl.codec.hex.fromBits( sjcl.hash.sha256.hash(newPwd) );
                //alert(newPwd);
                document.LoginForm.hashedPassword.value = newPwd;
                document.LoginForm.password.value = "";
                return true;
            }
            
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
                if(mail.length < 6 || !mail.includes("@"))
                {
                    // chiama ajax che controlla se la email è presente nel db
                    //if(checkEmailExists(mail)) {          
                      document.getElementById("alertResetPassword").style.visibility = "visible";
                    //  return false;
                   // }
                    return false;
                }else {
                    // chiudo la modal
                    $('#modalPasswordReset').modal('hide');
                    return true;
                }
            }
            
            // chiamata ajax
            /*function checkEmailExists(mail)
            {
                $.post("ElaboraDati.php?operazione=checkEmail", 
		{  
                    _mail : mail,
		},
		function(data)
		{
                    alert(data);
                    return true;
                }).fail(function () {
                    return false;
		});
            }*/
    
            console.log("- <%=request.getParameter("p") %>" );
        </script>
        
    </head>
    <body>        
        <nav class="navbar navbar-light bg-faded">
            <a class="navbar-brand" href="index.jsp"><span class="glyphicon glyphicon-home"></span> Torna alla Home </a>
        </nav> 
               
        <div class="container-fluid">
            <div class="row" style="text-align: center">
                LOGO BELLO DI Amazoff 
            </div>
            
            <!-- LOGIN -->
            <div class="col-xs-12 col-lg-6" >
                <div class="row">
                    
                    <div>
                        <div class="row">
                            <h3 style="text-align: center">Login:</h3>
                        </div>
                    </div>
  
                    <div class="col-xs-12">
                        <form style="text-align: center" class="form-group" id="LoginForm" name="LoginForm" action="ServletLogin" method="POST" onsubmit="return HashPasswordLogin();">
                            <div>
                                <input name="username" type="text" class="form-control" placeholder="Username" aria-describedby="sizing-addon2">
                            </div>
                            <div class="input-group">

                                <input id="pwdLogin" type="password" name="password" class="form-control" placeholder="Password" aria-describedby="sizing-addon2">
                                <input id="hashedPassword" type="hidden" name="hashedPassword" value="pigreco" />
                                <span class="input-group-btn">
                                    <a id="btnpwdLogin" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('pwdLogin')">
                                        <span id="spanpwdLogin" class="glyphicon glyphicon-eye-open"></span>
                                    </a>
                                </span>
                            </div>
                            <br/>
                            <button class="btn btn-default" type="submit">Accedi</button>
                            <a href="index.jsp" class="btn btn-danger">Annulla</a>    
                            <p class="tmargin">Password dimenticata? 
                                <a href="" style="color: blue" data-toggle="modal" data-target="#modalPasswordReset">Ripristina</a>
                            </p>
                        </form> 
                        <!-- div che visualizza il messaggio di errore durante il login -->
                        <% if(request.getParameter("p") != null && request.getParameter("p").equals("e1")) { %>
                            <div class="alert alert-danger alert-dismissible" id="alertRegistrati" role="alert">
                                <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                <strong>Errore!</strong> L'email o la password non sono corrette. Riprova.
                            </div>
                        <% } %>
                    </div>
                </div>
            </div> 
            
            <!-- div che inserisce una linea orizzontale tra le due form -->
            <div class="col-xs-12 hidden-lg">
                <hr>
            </div>
            
            <!-- REGISTRATI -->
            <div class="col-xs-12 col-lg-5" >
                <div class="row" >
                <div class="col-xs-12 col-lg-12"><h3 style="text-align: center">Registrati:</h3></div>
                <div class="col-xs-12 col-lg-12">
                    <form  style="text-align: center" class="form-group" id="RegisterForm" name="RegisterForm" action="ServletRegister" method="POST" onsubmit="return HashPasswordRegister();">
                        
                        <div>
                            <input id="mailRegister" type="text" name="email" class="form-control" placeholder="Email" aria-describedby="sizing-addon2">
                        </div>
                        <div>
                            <input id="usernameRegister" type="text" name="username" class="form-control" placeholder="Username" aria-describedby="sizing-addon2">
                        </div>
                        <div>
                            <input id="nameRegister" type="text" name="name" class="form-control" placeholder="Nome" aria-describedby="sizing-addon2">
                        </div>
                        <div>
                            <input id="surnameRegister" type="text" name="surname" class="form-control" placeholder="Cognome" aria-describedby="sizing-addon2">
                        </div>
                        <div class="input-group">
                            <input id="pwdRegister" type="password" name="password" class="form-control" placeholder="Password" aria-describedby="sizing-addon2">
                            <span class="input-group-btn">
                                <a id="btnpwdRegister" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('pwdRegister')">
                                    <span id="spanpwdRegister" class="glyphicon glyphicon-eye-open"></span>
                                </a>
                            </span>
                        </div>
                        <div class="input-group">
                            <input id="pwdRegisterConfirm" type="password" class="form-control" placeholder="Ripeti password" aria-describedby="sizing-addon2">
                            <input id="hashedPassword" type="hidden" name="hashedPassword" value="pigreco" />
                            <span class="input-group-btn">
                                <a id="btnpwdRegisterConfirm" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('pwdRegisterConfirm')">
                                    <span id="spanpwdRegisterConfirm" class="glyphicon glyphicon-eye-open"></span>
                                </a>
                            </span>
                        </div>
                        <div class="tmargin">
                            <input type="checkbox" id="cbCondizioni" aria-label="..." onclick="statoTerminiCondizioni()"> Conferma di aver letto e accettato le 
                            <a href="" style="color: blue" data-toggle="modal" data-target="#modalCondizioni">condizioni <span class="glyphicon glyphicon-info-sign"></span> </a>
                        </div>
                        
                        <div class="tmargin">
                            <button id="btnRegistrati" class="btn btn-default" disabled="true" title="Accetta le condizioni per continuare" >Registrati</button>
                            <a href="index.jsp" class="btn btn-danger">Annulla</a>
                        </div>
                    </form>
                    <div class="alert alert-danger alert-dismissible" style="visibility: hidden" id="alertRegistrati" role="alert">
                        
                        <!-- div che visualizza il messaggio di errore durante il login -->
                        <% if(request.getParameter("p") != null && request.getParameter("p").equals("e2")) { %>
                            <script>MostraErrore("L'username è già in uso. Selezionane un altro e riprovare.");</script>
                            <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                
                        <% } %>
                        
                    </div>
                </div>
            </div>
            </div>
        </div>

        <!-- Modal: popup che compare quando chiamo la funzione modalCondizioni  -->
        <div class="modal fade" id="modalCondizioni" tabindex="-1" role="dialog" aria-labelledby="exampleModalLongTitle" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLongTitle">Termini e condizioni - Amazoff</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                  Per continuare con la registrazione è necessario accettare le seguenti condizioni: <br>
                  - in caso di problemi di qualsiasi natura, la colpa non è mai nostra ma sempre del cliente <br>
                  - se dovessimo venire hackerati, nessun rimborso vi sarà reso, in nessuna occasione <br>
                  - nel caso l'utente (cioè lei) decidesse di vendere un prodotto, 
                  dovrà prendersi la completa responsabilità delle sue azioni, 
                  e in caso di infrazioni legali noi non saremo responsabili in nessun modo.<br>
                  PS. "Da grandi poteri derivano grandi reponsabilità" cit. quindi attenzione<br>
                  
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="statoTerminiCondizioni()">Accetto</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">Annulla</button>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Modal per il reset della password -->
        <div class="modal fade" id="modalPasswordReset" tabindex="-1" role="dialog"  aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <!-- Modal Header -->
                    <div class="modal-header">
                        <button type="button" class="close" 
                           data-dismiss="modal">
                               <span aria-hidden="true">&times;</span>
                               <span class="sr-only">Close</span>
                        </button>
                        <h4 class="modal-title" id="myModalLabel">
                            Ripristina la password
                        </h4>
                    </div>

                    <!-- Modal Body -->
                    <div class="modal-body">

                        <form class="form-horizontal" role="form">
                          <div class="form-group">
                            <label  class="col-sm-2 control-label"
                                      for="inputEmail3">Email</label>
                            <div class="col-sm-10">
                                <input type="email" class="form-control" 
                                id="inputEmail" placeholder="Inserisci Email"/>
                                <label  class="control-label">Ti verrà mandata una email con cui ripristinare la password.</label>  

                            </div>
                          </div>

                        </form>
                        <div class="alert alert-danger alert-dismissible" style="visibility: hidden" id="alertResetPassword" role="alert">
                            Indizizzo e-Mail non valido
                        </div>

                    </div>

                            <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Annulla</button>
                        <button type="button" class="btn btn-primary" onclick="checkResetEmail()">Ripristina</button>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
