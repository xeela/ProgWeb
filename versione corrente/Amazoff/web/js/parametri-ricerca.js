function RadioSwitch(value){
    $("#categoriaRicerca").val(value);
    Autocomplete(value);
}

function impostaRecensione(value){
    if($("#recensioneRicerca").length){
        if(value === "all"){
            $("#recensioneRicerca").remove();
        } else{
            $("#recensioneRicerca").val(value);
        }
    } else if (value !== 'all'){
        $("#parametriRicerca").append('<input id="recensioneRicerca" name="recensioneRicerca" type="text" style="display:none;" value="">');
        $("#recensioneRicerca").val(value);
    }
}

function impostaDistanzaWrapper(obj){
    var dist = obj.value;    
    impostaDistanza(dist);
}

function impostaDistanza(dist){
    if(dist === ""){
        if($("#distanzaRicerca").length){
            $("#distanzaRicerca").remove();
        }
        
        if($("#latRicerca").length){
            $("#latRicerca").remove();
        }
        
        if($("#lngRicerca").length){
            $("#lngRicerca").remove();
        }
    } else {
        if($("#distanzaRicerca").length){
            $("#distanzaRicerca").val(dist);
        } else {
            $("#parametriRicerca").append('<input id="distanzaRicerca" name="distanzaRicerca" type="text" style="display:none;" value="">');
            $("#distanzaRicerca").val(dist);
        }
        
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(impostaLatLng);
        } else {
            alert("Geolocation is not supported by this browser");
        }
    }
}

function impostaLatLngWrapper(position){
    var lat = position.coords.latitude;
    var lng = position.coords.longitude;
    impostaLatLng(lat, lng);
}

function impostaLatLng(lat, lng){
    
    if($("#latRicerca").length){
        $("#latRicerca").val(lat);
        $("#lngRicerca").val(lng);
    } else {
        $("#parametriRicerca").append('<input id="latRicerca" name="latRicerca" type="text" style="display:none;" value="">');
        $("#latRicerca").val(lat);
        $("#parametriRicerca").append('<input id="lngRicerca" name="lngRicerca" type="text" style="display:none;" value="">');
        $("#lngRicerca").val(lng);
    }
}

function impostaMinWrapper(obj){
    var min = parseInt(obj.value);
    impostaMin(min);
}

function impostaMin(min) {
    var remove = false;

    if($("#prezzoMaxRicerca").length){
        if(min > parseInt($("#prezzoMaxRicerca").val())){
            alert("Il prezzo minimo deve essere minore del prezzo massimo!");
            $('#prezzoDa').value = "";
            $('#prezzoDa_xs').value = "";
            remove = true;
        }
    }

    if($("#prezzoMinRicerca").length){
        if((min === "") || remove){
            $("#prezzoMinRicerca").remove();
        } else {
            $("#prezzoMinRicerca").val(min);
        }
    } else if ((min !== "") && !remove){
        $("#parametriRicerca").append('<input id="prezzoMinRicerca" name="prezzoMinRicerca" type="text" style="display:none;" value="">');
        $("#prezzoMinRicerca").val(min);
    }
}

function impostaMaxWrapper(obj){
    var max = parseInt(obj.value);
    impostaMax(max);
}

function impostaMax(max) {
    var remove = false;

    if($("#prezzoMinRicerca").length){
        if(max < parseInt($("#prezzoMinRicerca").val())){
            alert("Il prezzo massimo deve essere maggiore del prezzo minimo!");
            $('#prezzoA').value = "";
            $('#prezzoA_xs').value = "";
            remove = true;
        }
    }

    if($("#prezzoMaxRicerca").length){
        if((max === "") || remove){
            $("#prezzoMaxRicerca").remove();
        } else {
            $("#prezzoMaxRicerca").val(max);
        }
    } else if ((max !== "") && !remove){
        $("#parametriRicerca").append('<input id="prezzoMaxRicerca" name="prezzoMaxRicerca" type="text" style="display:none;" value="">');
        $("#prezzoMaxRicerca").val(max);
    }
}

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if ((charCode > 31) && (charCode < 48 || charCode > 57)){
        return false;
    } else {
        return true;
    }
}