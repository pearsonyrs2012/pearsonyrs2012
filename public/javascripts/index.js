jQuery(window).ready(function(){  
	$.ajax({
      url: "api/settings/",
      dataType: "json",
      success: function(response) { 
		//general
		$('body').css('background-color','#' + response.backcolour)
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
    });
});  


	//soundManager.setup({

  // location: path to SWF files, as needed (SWF file name is appended later.)

 // url: 'javascripts/soundmanager/swf/',


  // use soundmanager2-nodebug-jsmin.js, or disable debug mode (enabled by default) after development/testing
  // debugMode: false,

  // good to go: the onready() callback

  //onready: function() {

    // SM2 has started - now you can create and play sounds!

    //var mySound = soundManager.createSound({
      //id: 'alert',
      //url: '/path/'
      // onload: function() { console.log('sound loaded!', this); }
      // other options here..
    //});

    //mySound.play();
// },

  // optional: ontimeout() callback for handling start-up failure

//  ontimeout: function() {

    // Hrmm, SM2 could not start. Missing SWF? Flash blocked? Show an error, etc.?
    // See the flashblock demo when you want to start getting fancy.

 // }
	
//});

function handle_geolocation_query(position){
	
  	

	$.ajax({
      url: "api/home/" + position.coords.latitude + "/" + position.coords.longitude + "/",
      dataType: "json",
      success: function(response) { 
        console.log("success");
		console.log(response.bigest.presentation_name);
		$("#bigist").text(response.bigest.presentation_name);
		$("#fourthcolumn").text(response.secondbigist.presentation_name);
		$("#lowist").text(response.lowist.presentation_name);
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
			  var name = $(this)[0]["name"]
			  var imageid = '#' + name + 'levelimg'
			  		$(imageid).src = "images/icons/help.png";
					$(imageid).alt = "Error";
            }
    });
    

}
