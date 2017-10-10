$(function(){	
  var products = [
     'agenda',
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
  $('#txtCerca').focusin(function(){
		var $category = document.getElementById('search_category').value;
		if($category == 'product'){
			$('#txtCerca').autocomplete({
				lookup: products
			});
		} else if ($category == 'seller') {
			$('#txtCerca').autocomplete({
				lookup: sellers
			});
		}
  });
});