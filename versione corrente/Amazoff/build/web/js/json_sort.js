function LogJson() {
    console.log(jsonProdotti);
    //console.log(jsonNotifiche);
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
        toAdd += "<p name=\"stelle" + id_oggetto + "\">Voto totale</p>";
        toAdd += "<p name=\"recensioni" + id_oggetto + "\">Tot recensioni: "+ jsonProdotti.products[i].num_reviews +"</p>";
        toAdd += "<p name=\"linkmappa" + id_oggetto + "\" >Vedi su mappa TO DO</p>";
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

/*// dato un elemento text input, reindirizza alla pagina searchPage passando in get il valore nella txt
 function cercaProdotto(txt)
 {
 window.location = "/Amazoff/ServletFindProduct?p=" + document.getElementById(txt).value;
 }*/