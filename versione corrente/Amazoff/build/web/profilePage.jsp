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
            
           
            <!-- REGISTRATI -->
            <div class="col-12" >
                <div class="row" >
                <div class="col-lg-12"><h3 style="text-align: center">Aggiorna le tue credenziali:</h3></div>
                <div class="col-lg-12">
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
                    <div class="alert alert-danger alert-dismissible" style="visibility: hidden" id="alertRegistrati" role="alert">
                        <!--<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>-->
                    </div>
                </div>
            </div>
            </div>
        </div>

        
    </body>
</html>
