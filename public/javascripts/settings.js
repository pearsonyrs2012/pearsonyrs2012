$(document).ready( function() {

//
// Enabling miniColors
//
	$.ajax({
      url: "api/settings/",
      dataType: "json",
      success: function(response) { 
        console.log("success");
		$('#backgroundcolour').miniColors('value', response.backcolour);
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
    });
$(".color-picker").miniColors({
letterCase: 'uppercase',
change: function(hex, rgb) {
},
open: function(hex, rgb) {
},
close: function(hex, rgb) {
}
});

});

function savesettings () {
var background = $('#backgroundcolour').miniColors('value');
var url = "api/settings/colour/" + background + "/"
	$.ajax({
      url: url,
      dataType: "json",
      success: function(response) { 
        console.log("success");
		$('#backgroundcolour').miniColors('value', response.backcolour);
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
    });
}