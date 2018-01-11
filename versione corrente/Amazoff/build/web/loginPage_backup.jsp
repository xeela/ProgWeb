<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js"></script>
        <link rel="stylesheet" href="css/bootstrap.css">
        <link rel="shortcut icon" href="favicon.ico" type="image/x-icon" />
        <link rel="stylesheet" href="css/bootstrap-theme.css">
        <script src="js/bootstrap.min.js"></script>
        <script type="text/javascript" src="js/sjcl.js" ></script>
        <script type="text/javascript">

            function MostraErrore(text)
            {
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

        </script>

    </head>
    <body>
        <div class="container-fluid">

            <!-- LOGIN -->
            <div class="col-xs-12 col-lg-5" >
                <div class="row">
                    <div class="col-xs-12">
                        <h3 style="text-align: center">Login:</h3>
                    </div>

                    <div class="col-xs-12">
                        <form style="text-align: center" class="form-group col-xs-12" id="LoginForm" name="LoginForm" action="ServletLogin" method="POST" onsubmit="return HashPasswordLogin();">
                            <div>
                                <input name="username" type="text" class="form-control" placeholder="Username" aria-describedby="sizing-addon2">
                            </div>
                            <!-- OSS: NON VA IL BUTTON mostra nascondi -->
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
                        </form>
                    </div>
                </div>
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
                                <input id="pwdRegisterConfirm" type="password" class="form-control" placeholder="Password" aria-describedby="sizing-addon2">
                                <input id="hashedPassword" type="hidden" name="hashedPassword" value="pigreco" />
                                <span class="input-group-btn">
                                    <a id="btnpwdRegisterConfirm" class="btn btn-default" type="button" title="Mostra password" onclick="show_hide_pass('pwdRegisterConfirm')">
                                        <span id="spanpwdRegisterConfirm" class="glyphicon glyphicon-eye-open"></span>
                                    </a>
                                </span>
                            </div>
                            <br/>
                            <button class="btn btn-default" >Registrati</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
