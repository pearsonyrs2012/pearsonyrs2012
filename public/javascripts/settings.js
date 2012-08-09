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
		console.log(response);
		if (response.cookies == 0) {		
		var answer = confirm ("do you give us permission to place cookies on your computer so we can save your settings?");
		if (answer) {
			$.ajax({
				url: "api/settings/cookies/1/",
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
			$('#cookiesbox').attr("checked") = "checked";
			}
		}
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
if (cookies.checked == false) {		
var answer = confirm ("do you give us permission to place cookies on your computer so we can save your settings?");
if (answer)
	$.ajax({
	url: "api/settings/cookies/1/",
	dataType: "json",
	success: function(response) { 
	console.log("success");
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
	},
	error: function(xhr,text,errort) {console.log(xhr);
		console.log("failed");
		console.log(text);
		console.log(errort);
		}
	});


} else {
	$.ajax({
	url: "api/settings/cookies/0/",
	dataType: "json",
	success: function(response) { 
	console.log("success");
	var background = $('#backgroundcolour').miniColors('value');
	},
	error: function(xhr,text,errort) {console.log(xhr);
		console.log("failed");
		console.log(text);
		console.log(errort);
		}
	});
}
}