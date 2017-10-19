$(function () {
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
        'winows 10',
        'xiaomi',
        'yoyo',
        'zaino'
    ];

    var sellers = [
        'phonetech',
        'onlineshop',
        'games&games'
    ];

// autocomplete function
    $('#txtCerca').focusin(function () {
        if ($('div[name=filters]').is(":visible")) {
            var $category = $('input[name=categoria]:checked').val();
            if ($category == 'product') {
                $('#txtCerca').autocomplete({
                    lookup: products
                });
            } else if ($category == 'seller') {
                $('#txtCerca').autocomplete({
                    lookup: sellers
                });
            }
        }
        else{
            var $category = $('input[name=categoria_xs]:checked').val();
            if ($category == 'product') {
                $('#txtCerca').autocomplete({
                    lookup: products
                });
            } else if ($category == 'seller') {
                $('#txtCerca').autocomplete({
                    lookup: sellers
                });
            }
        }
    });
});