function LogJson() {
    console.log("LOGJSON");
    console.log(jsonProdotti);
    console.log(jsonNotifiche);
    console.log("-----");
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
    jsonProdotti.products = jsonProdotti.products.sort(function (a, b) {
        switch (param) {
            case 'price_asc':
                return (a.price > b.price);
                break;
            case 'price_desc':
                return (a.price < b.price);
                break;
                //case 'review_asc': return (a.price > b.price); break;
                //case 'review_desc': return (a.price < b.price); break;
            default:
                break;
        }
    });
    AggiungiProdotti();
}

function AggiungiProdotti() {
    var toAdd = "";
    var id_oggetto = -1;
    var path = "default.jpg";

    for (var i = 0; i < jsonProdotti.products.length; i++)
    {
        id_oggetto = jsonProdotti.products[i].id;
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
        //toAdd += "<div class=\"hidden-xs col-sm-2 col-md-1\" >";
        //toAdd += "<span class=\"prova glyphicon glyphicon-chevron-right\"></span>";
        //toAdd += "</div>";
        toAdd += "</div></form><hr>";
    }

    $("#zonaProdotti").html(toAdd);
}

function AggiungiOrdini() {
    var toAdd = "";
    var id_oggetto = -1;
    var path = "default.jpg";

    for (var i = 0; i < jsonProdotti.orders.length; i++)
    {
        id_oggetto = jsonProdotti.orders[i].id;
        toAdd += "<p name=\"id_ordine" + id_oggetto + "\">Numero ordine: </p>" + jsonProdotti.orders[i].products[0].order_id + "</p>";
        for (var j = 0; j < jsonProdotti.orders[i].products.length; j++) {
            toAdd += "<div class=\"row\">";
            toAdd += "<form method=\"post\" action=\"/Amazoff/ServletPopulateProductPage?id=" + id_oggetto + "\" id=\"form" + id_oggetto + "\" onclick=\"$('#form" + id_oggetto + "').submit();\"> ";
            toAdd += "<div class=\"thumbnail col-xs-4 col-sm-3 col-md-2\" style=\"min-height:100px;  \">";
            if(jsonProdotti.orders[i].products[j].pictures.length == 0)
                path = "default.jpg";
            else
                path = jsonProdotti.orders[i].products[j].pictures[0].path; // visualizzo solo la prima immagine del prodotto
            toAdd += "<img src=\"UploadedImages/" + path + "\" style=\"max-height: 100px; \" onerror=\"this.src='UploadedImages/default.jpg'\">";
            toAdd += "</div>";
            toAdd += "<div class=\"col-xs-8 col-sm-7 col-md-9\">";
            toAdd += "<p name=\"data_ordine" + id_oggetto + "\">Data ordine: </p>" + jsonProdotti.orders[i].products[j].order_date + "</p>";
            toAdd += "<p name=\"nome" + id_oggetto + "\" >" + jsonProdotti.orders[i].products[j].name + "</p>";
            toAdd += "<p name=\"stelle" + id_oggetto + "\">Voto totale</p>";
            toAdd += "<p name=\"recensioni" + id_oggetto + "\">Tot recensioni: "+ jsonProdotti.orders[i].products[j].num_reviews +"</p>";
            toAdd += "<p name=\"linkmappa" + id_oggetto + "\" ><a href='ServletShowShopOnMap?id="+jsonProdotti.orders[i].products[j].id_shop+"'>Vedi su mappa</a></p>";
            toAdd += "<p name=\"prezzo" + id_oggetto + "\">Prezzo: " + jsonProdotti.orders[i].products[j].price + "€</p>";
            toAdd += "<p name=\"venditore" + id_oggetto + "\" >Venditore: "+ jsonProdotti.orders[i].products[j].last_name +" "+ jsonProdotti.orders[i].products[j].first_name +"</p>";
            toAdd += "<p><a href=\""+jsonProdotti.orders[i].products[j].site_url+"\">Sito Negozio: "+jsonProdotti.orders[i].products[j].shop_name+"</a></p>";
            toAdd += "</div>";
            toAdd += "<p><a href=\"ServletRecensione?id="+jsonProdotti.orders[i].products[j].product_id+"\" class=\"btn btn-primary\" role=\"button\">Lascia recensione</a></p>";
            toAdd += "</div></form><hr>";
        }
    }

    $("#zonaProdotti").html(toAdd);
}

function Recensione(id){
    
}