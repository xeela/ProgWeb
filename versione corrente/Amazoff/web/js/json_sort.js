/* global jsonProdotti, jsonNotifiche, productSearched */

function LogJson() {
    console.log(jsonProdotti);
    console.log(jsonNotifiche);

    RiempiBarraRicerca();
    AggiungiProdotti();
}

function RiempiBarraRicerca() {
    $("#txtCerca").val(productSearched);
}

$(function () {
    $('#sorting td').click(function () {
        sortResults($(this).attr('id'));
    });

    $('#sorting li').click(function () {
        sortResults($(this).attr('id'));
    });
});

function sortResults(param) {
    $("#parametriRicerca").append('<input id="sort_by" name="sort_by" type="text" style="display:none;" value="' + param + '">');
    $('#formSearch').submit();

    /*
    jsonProdotti.products = jsonProdotti.products.sort(function (a, b) {
        switch (param) {
            case 'price_asc':
                return (a.price - b.price);
                break;
            case 'price_desc':
                return (b.price - a.price);
                break;
            case 'review_asc':
                return (a.global_value_avg > b.global_value_avg);
                break;
            case 'review_desc':
                return (a.global_value_avg < b.global_value_avg);
                break;
            default:
                break;
        }
    });
    AggiungiProdotti();
    */
}

function AggiungiProdotti() {
    var toAdd = "";
    var id_oggetto = -1;
    var path = "default.jpg";

    for (var i = 0; i < jsonProdotti.products.length; i++)
    {
        id_oggetto = jsonProdotti.products[i].id;
        toAdd += "<div class=\"row thumbnail hovertable\" >";
        toAdd += "<form method=\"post\" action=\"/Amazoff/ServletPopulateProductPage?id=" + id_oggetto + "\" id=\"form" + id_oggetto + "\" onclick=\"$('#form" + id_oggetto + "').submit();\"> ";
        toAdd += "<div class=\"col-xs-5 col-sm-3 col-md-2\" >";
        if (jsonProdotti.products[i].pictures.length === 0)
            path = "default.jpg";
        else
            path = jsonProdotti.products[i].pictures[0].path; // visualizzo solo la prima immagine del prodotto
        toAdd += "   <img src=\"UploadedImages/" + path + "\" style=\"max-width:100%; \" onerror=\"this.src='UploadedImages/default.jpg'\">";
        toAdd += "</div>";
        toAdd += "<div class=\"col-xs-7 col-sm-7 col-md-9\">";
        toAdd += "<h3 name=\"nome" + id_oggetto + "\" >" + jsonProdotti.products[i].name + "</h3>";

        toAdd += "<div class=\"row\">";
        toAdd += "<p class=\"col-xs-12 col-sm-6\" name=\"stelle" + id_oggetto + "\">Voto totale: " + jsonProdotti.products[i].global_value_avg + "</p>";
        toAdd += "<p class=\"col-xs-12 col-sm-6\" name=\"recensioni" + id_oggetto + "\">Tot recensioni: " + jsonProdotti.products[i].num_reviews + "</p>";
        toAdd += "</div>";

        toAdd += "<p name=\"venditore" + id_oggetto + "\" >Venditore: " + jsonProdotti.products[i].last_name + " " + jsonProdotti.products[i].first_name + "</p>";

        toAdd += "<div class=\"row\">";
        toAdd += "<p class=\"col-xs-12 col-sm-6\" ><a href=\"" + jsonProdotti.products[i].site_url + "\">Sito Negozio: " + jsonProdotti.products[i].shop_name + "</a></p>";
        toAdd += "<p  class=\"col-xs-12 col-sm-6\" name=\"linkmappa" + id_oggetto + "\" ><a href='ServletShowShopOnMap?id=" + jsonProdotti.products[i].id_shop + "'>Vedi su mappa</a></p>";
        toAdd += "</div>";

        toAdd += "<h4 name=\"prezzo" + id_oggetto + "\">Prezzo: " + jsonProdotti.products[i].price + "€</h4>";
        toAdd += "</div>";
        toAdd += "</form></div>";
        // toAdd += "<hr>";
    }

    $("#zonaProdotti").html(toAdd);
    
    if(jsonProdotti.products[0].categoriaReceived !== "null"){
        RadioSwitch(jsonProdotti.products[0].categoriaReceived);
    }
    if(jsonProdotti.products[0].recensioneReceived !== "null"){
        impostaRecensione(jsonProdotti.products[0].recensioneReceived);
    }
    if(jsonProdotti.products[0].distanzaReceived !== "null"){
        impostaDistanza(jsonProdotti.products[0].distanzaReceived);
    }
    if(jsonProdotti.products[0].prezzoMinRicerca !== "null"){
        impostaMin(jsonProdotti.products[0].prezzoMinRicerca);
    }
    if(jsonProdotti.products[0].prezzoMaxRicerca !== "null"){
        impostaMax(jsonProdotti.products[0].prezzoMaxRicerca);
    }
    if(jsonProdotti.products[0].userLat !== "null"){
        impostaLatLng(jsonProdotti.products[0].userLat, jsonProdotti.products[0].userLng);   
    }
}

/* BACKUP:
 toAdd += "<div class=\"row\">";
 toAdd += "<form method=\"post\" action=\"/Amazoff/ServletPopulateProductPage?id=" + id_oggetto + "\" id=\"form" + id_oggetto + "\" onclick=\"$('#form" + id_oggetto + "').submit();\"> ";
 toAdd += "<div class=\"thumbnail col-xs-4 col-sm-3 col-md-2\" style=\"min-height:100px;  \">";
 console.log(jsonProdotti.products[i].path);
 if(jsonProdotti.products[i].pictures.length == 0)
 path = "default.jpg";
 else
 path = jsonProdotti.products[i].pictures[0].path; // visualizzo solo la prima immagine del prodotto
 toAdd += "   <img src=\"UploadedImages/" + path + "\" style=\"max-height: 100px; \" onerror=\"this.src='UploadedImages/default.jpg'\">";
 toAdd += "</div>";
 toAdd += "<div class=\"col-xs-8 col-sm-7 col-md-9\">";
 toAdd += "<p name=\"nome" + id_oggetto + "\" >" + jsonProdotti.products[i].name + "</p>";
 toAdd += "<p name=\"stelle" + id_oggetto + "\">Voto totale: "+ jsonProdotti.products[i].global_value_avg +"</p>";
 toAdd += "<p name=\"recensioni" + id_oggetto + "\">Tot recensioni: "+ jsonProdotti.products[i].num_reviews +"</p>";
 toAdd += "<p name=\"linkmappa" + id_oggetto + "\" ><a href='ServletShowShopOnMap?id="+jsonProdotti.products[i].id_shop+"'>Vedi su mappa</a></p>";
 toAdd += "<p name=\"prezzo" + id_oggetto + "\">Prezzo: " + jsonProdotti.products[i].price + "€</p>";
 toAdd += "<p name=\"venditore" + id_oggetto + "\" >Venditore: "+ jsonProdotti.products[i].last_name +" "+ jsonProdotti.products[i].first_name +"</p>";
 toAdd += "<p><a href=\""+jsonProdotti.products[i].site_url+"\">Sito Negozio: "+jsonProdotti.products[i].shop_name+"</a></p>";
 toAdd += "</div>";
 toAdd += "</div></form><hr>";
 
 */

function AggiungiOrdini() {
    var toAdd = "";
    var id_ordine = -1;
    var path = "default.jpg";

    if(jsonProdotti.orders[0].products[0].order_id === "empty"){
        toAdd += "<h2>Nessun ordine effettuato.</h2>";
    } else {
        for (var i = 0; i < jsonProdotti.orders.length; i++)
        {
            id_ordine = jsonProdotti.orders[i].products[0].order_id;
            toAdd += "<div id='" + id_ordine + "'><h3 name=\"id_ordine" + id_ordine + "\">Numero ordine: " + jsonProdotti.orders[i].products[0].order_id + "</h3>";
            for (var j = 0; j < jsonProdotti.orders[i].products.length; j++) {
                toAdd += "<div class=\"row\">";
                toAdd += "<form method=\"post\" action=\"/Amazoff/ServletPopulateProductPage?id=" + id_ordine + "\" id=\"form" + id_ordine + "\" onclick=\"$('#form" + id_ordine + "').submit();\"> ";
                toAdd += "<div class=\"thumbnail col-xs-4 col-sm-3 col-md-2\" style=\"min-height:100px;  \">";
                if (jsonProdotti.orders[i].products[j].pictures.length === 0)
                    path = "default.jpg";
                else
                    path = jsonProdotti.orders[i].products[j].pictures[0].path; // visualizzo solo la prima immagine del prodotto
                toAdd += "<img src=\"UploadedImages/" + path + "\" style=\"max-height: 100px; \" onerror=\"this.src='UploadedImages/default.jpg'\">";
                toAdd += "</div>";
                toAdd += "<div class=\"col-xs-8 col-sm-7 col-md-9\">";
                toAdd += "<p name=\"nome" + id_ordine + "\" >" + jsonProdotti.orders[i].products[j].name + "</p>";
                toAdd += "<p name=\"data_ordine" + id_ordine + "\">Data ordine: " + jsonProdotti.orders[i].products[j].order_date + "</p>";
                toAdd += "<p name=\"prezzo" + id_ordine + "\">Prezzo: " + jsonProdotti.orders[i].products[j].price + " €</p>";
                toAdd += "<p><a href=\"ServletRecensione?id=" + jsonProdotti.orders[i].products[j].product_id + "\" class=\"btn btn-primary\" role=\"button\">Lascia recensione</a></p>";
                toAdd += "<p><a href=\"ServletSegnalazione?orderId=" + id_ordine + "&productId=" + jsonProdotti.orders[i].products[j].product_id + "\" class=\"btn btn-primary\" role=\"button\">Segnala non arrivato</a></p>";
                toAdd += "</div>";
                toAdd += "</div></form><hr>";
            }
            toAdd += "</div>";
        }
    }
    $("#zonaProdotti").html(toAdd);
}