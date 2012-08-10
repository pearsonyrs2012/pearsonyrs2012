jQuery(window).ready(function(){  
  initiate_geolocation()
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

function initiate_geolocation() {  
    navigator.geolocation.getCurrentPosition(handle_geolocation_query);  
} 

function handle_geolocation_query(position){
  
  	placename(position.coords.latitude, position.coords.longitude)

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
    
    //do this again in a bit
    setTimeout(initiate_geolocation, 15000);
}

function placename(lat, long) {
		var geocoder;
		geocoder = new google.maps.Geocoder();
		var latlng = new google.maps.LatLng(lat, long);
		geocoder.geocode({'latLng': latlng}, function(results, status) {
			$("#address").html(results[0]["formatted_address"])
		})
}