var items;

function Autocomplete(categoria){
    $.post('ServletAjaxAutocomplete', {
        _categoria: categoria
    },
    function(data) {
        items = data.split(",");
    }).fail(function () {
        alert("ajax error");
    });
}

$(function () {    
    /*
    var products = [
        'aventador',
        'bilancia',
        'cuffie',
        'drone',
        'eyeliner',
        'fifa 18',
        'go pro',
        'hdmi',
        'iphone',
        'joystick',
        'kindle',
        'lego',
        'mouse',
        'nike',
        'ombrello',
        'ps4',
        'quaderno',
        'rasoio',
        'ssd',
        'tiragraffi',
        'usb',
        'vans',
        'windows 10',
        'xiaomi',
        'yoyo',
        'zaino'
    ];
    
    var categories = [
        'abbigliamento',
        'alimentari',
        'auto',
        'bellezza',
        'cancelleria',
        'casa',
        'cd',
        'elettronica',
        'film',
        'giochi',
        'gioielli',
        'illuminazione',
        'informatica',
        'libri',
        'musica',
        'orologi',
        'salute',
        'sport',
        'valige',
        'videogiochi'
    ];
    
    var sellers = [
        'phonetech',
        'onlineshop',
        'games&games'
    ];
    */
   
// autocomplete function
    $('#txtCerca').focusin(function () {
        var $param = $("#categoriaRicerca").val();
        
        /*
        if ($('div[name=filters]').is(":visible")) {
            $param = $('input[name=categoria]:checked').val();
        }
        else{
            $param = $('input[name=categoria_xs]:checked').val();
        }*/
        
        if ($param === 'product') {
            Autocomplete("product");
        } else if ($param === 'category') {
            Autocomplete("category");
        } else if ($param === 'seller') {
            Autocomplete("seller");
        }
        
        $('#txtCerca').autocomplete({
            lookup: items
        });
    });
});