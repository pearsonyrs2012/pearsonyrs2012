$(document).ready( function() {

//
// Enabling miniColors
//
	$.ajax({
      url: "api/settings/",
      dataType: "json",
      success: function(response) { 
        console.log("successfully retrived settings on load");
		$('#backgroundcolour').miniColors('value', response.backcolour);
		if (response.cookies == 1) $('#cookiesbox').attr("checked", "checked")
		console.log(response);
		if (response.cookies == 0) {		
		var answer = confirm ("do you give us permission to place cookies on your computer so we can save your settings?");
		if (answer) {
			$.ajax({
				url: "api/settings/cookies/1/",
				dataType: "json",
				success: function(response) { 
				console.log("successfully set cookies");
				$('#backgroundcolour').miniColors('value', response.backcolour);	
				},
				error: function(xhr,text,errort) {console.log(xhr);
					console.log("failed");
					console.log(text);
					console.log(errort);
				}
			});
			$('#cookiesbox').attr("checked", "checked");
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
if ($("#cookiesbox:checked").val() == undefined) {		
var answer = confirm ("do you give us permission to place cookies on your computer so we can save your settings?");
if (answer) {
	$.ajax({
	url: "api/settings/cookies/1/",
	dataType: "json",
	success: function(response) { 
	console.log("successfully set cookies");


	},
	error: function(xhr,text,errort) {console.log(xhr);
		console.log("failed");
		console.log(text);
		console.log(errort);
		}
	 });	
		var background = $('#backgroundcolour').miniColors('value');
var url = "api/settings/colour/" + background.substring(1) + "/"
	$.ajax({
      url: url,
      dataType: "json",
      success: function(response) { 
        console.log("successfully set colour");
		$('#backgroundcolour').miniColors('value', response.backcolour);
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
			    });	
}

} else {
	$.ajax({
	url: "api/settings/cookies/1/",
	dataType: "json",
	success: function(response) { 
	console.log("successfull set cookies");
	var background = $('#backgroundcolour').miniColors('value');
	},
	error: function(xhr,text,errort) {console.log(xhr);
		console.log("failed");
		console.log(text);
		console.log(errort);
		}
	});
	var background = $('#backgroundcolour').miniColors('value');
	console.log(background);
	var url = "api/settings/colour/" + background.substring(1) + "/"
	console.log(url);
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
}