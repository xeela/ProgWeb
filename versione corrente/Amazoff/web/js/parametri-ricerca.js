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

function impostaMin(obj) {
    var min = obj.value;
    var remove = false;

    if($("#prezzoMaxRicerca").length){
        if(min > $("#prezzoMaxRicerca").val()){
            alert("Il prezzo minimo deve essere minore del prezzo massimo!");
            obj.value = "";
            remove = true;
        }
    }

    if($("#prezzoMinRicerca").length){
        if((min == "") || remove){
            $("#prezzoMinRicerca").remove();
        } else {
            $("#prezzoMinRicerca").val(min);
        }
    } else if ((min != "") && !remove){
        $("#parametriRicerca").append('<input id="prezzoMinRicerca" name="prezzoMinRicerca" type="text" style="display:none;" value="">');
        $("#prezzoMinRicerca").val(min);
    }
}

function impostaMax(obj) {
    var max = obj.value;
    var remove = false;

    if($("#prezzoMinRicerca").length){
        if(max < $("#prezzoMinRicerca").val()){
            alert("Il prezzo massimo deve essere maggiore del prezzo minimo!");
            obj.value = "";
            remove = true;
        }
    }

    if($("#prezzoMaxRicerca").length){
        if((max == "") || remove){
            $("#prezzoMaxRicerca").remove();
        } else {
            $("#prezzoMaxRicerca").val(max);
        }
    } else if ((max != "") && !remove){
        $("#parametriRicerca").append('<input id="prezzoMaxRicerca" name="prezzoMaxRicerca" type="text" style="display:none;" value="">');
        $("#prezzoMaxRicerca").val(max);
    }
}

function isNumberKey(evt){
    var charCode = (evt.which) ? evt.which : event.keyCode;
    if ((charCode > 31) && (charCode < 48 || charCode > 57)){
        return false;
    } else {
        return true;
    }
}