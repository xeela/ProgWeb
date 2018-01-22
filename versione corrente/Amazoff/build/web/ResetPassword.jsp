<%-- 
    Document   : ResetPassword
    Created on : Dec 28, 2017, 2:39:06 PM
    Author     : Fra
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <title>Amazoff</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <!-- *** senza questo, i col di bootstrap non funzionano correttamente *** -->
        <meta name="viewport" content="width=device-width, initial-scale=1"> 

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/sjcl.js" ></script>
        <link rel="stylesheet" href="css/amazoffStyle.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />

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

            function preRegistrationSubmit()
            {
                if ($("#txtMail").val() == "" || $("#txtPwdConfirm").val() == "" || $("#txtPwd").val() == "")
                {
                    MostraErrore("Completa tutti i campi prima di continuare.");
                    return false;
                }
                if ($("#txtPwd").val().length < 8 || $("#txtPwdConfirm").val().length < 8)
                {
                    MostraErrore("La password deve essere di almeno 8 caratteri");
                    return false;
                }
                if ($("#txtPwdConfirm").val() != $("#txtPwd").val())
                {
                    MostraErrore("Le due password non coincidono.");
                    return false;
                }
                return HashPassword();

            }

            function HashPassword()
            {
                var newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash($('#txtPwd').val()));
                for (var i = 0; i < 10000; i++)
                    newPwd = sjcl.codec.hex.fromBits(sjcl.hash.sha256.hash(newPwd));

                document.getElementById("hashedPassword").value = newPwd;
                document.getElementById("hashedPassword").value = "";

                return true;
            }

            function MostraErrore(text)
            {
                document.getElementById("alertMessage").innerHTML = "<strong>Errore!</strong> " + text;
                document.getElementById("alertMessage").style.visibility = "visible";

                console.log(text);
            }

        </script>
    </head>
    <body>
        <div class="col-xs-12 col-lg-6 col-lg-offset-3" >
            <div class="row" >
                <div class="col-xs-12 col-lg-12"><h3 style="text-align: center">Modifica password</h3></div>
                <div class="col-xs-12 col-lg-12">
                    <form  style="text-align: center" class="form-group" id="FormPwdReset" name="FormPwdReset" action="ServletRecuperoPassword" method="POST" onsubmit="return preRegistrationSubmit();">

                        <div class="input-group">
                            <input id="txtMail" type="text" name="email" class="form-control" placeholder="Email" aria-describedby="sizing-addon2">
                            <span class="input-group-addon" id="mailFieldIcon"><span class="glyphicon glyphicon-envelope"></span></span>
                        </div>

                        <div class="input-group">
                            <input id="txtPwd" type="password" name="password" class="form-control" placeholder="Password" aria-describedby="sizing-addon2">
                            <span class="input-group-btn">
                                <a id="btnpwdRegister" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('txtPwd')">
                                    <span id="spanpwdRegister" class="glyphicon glyphicon-eye-open"></span>
                                </a>
                            </span>
                        </div>
                        <div class="input-group">
                            <input id="txtPwdConfirm" type="password" class="form-control" placeholder="Ripeti password" aria-describedby="sizing-addon2">
                            <input id="hashedPassword" type="hidden" name="hashedPassword" value="pigreco" />
                            <input id="tmpPassword" type="hidden" name="tmpPassword" value="<%= request.getParameter("tmp") %>" />
                            <span class="input-group-btn">
                                <a id="btnpwdRegisterConfirm" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('txtPwdConfirm')">
                                    <span id="spanpwdRegisterConfirm" class="glyphicon glyphicon-eye-open"></span>
                                </a>
                            </span>
                        </div>
                        <br>
                        <button class="btn btn-primary" type="submit">Salva modifiche</button>
                    </form>
                    <div class="alert alert-danger alert-dismissible" id="alertMessage" role="alert" style="visibility: hidden">
                        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <strong>Errore!</strong>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
