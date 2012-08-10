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
      url: "api/overview/" + position.coords.latitude + "/" + position.coords.longitude + "/",
      dataType: "json",
      success: function(response) { 
        console.log("success");
        $(response).each(function(index) {
          
            // get values from response
            var level = $(this)[0]["level"]
            var name = $(this)[0]["name"]
            var pressentaionname = $(this)[0]["pressentaionname"]
			var imageid = '#' + name + 'levelimg'
			if ($(imageid)){
				if(level >= 0.5){
					$(imageid).attr("src","images/icons/high.png");
					$(imageid).attr("alt","High Level");
				}else{
					$(imageid).attr("src","images/icons/low.png");
					$(imageid).attr("alt","Low Level");
            }
			
			}

        });
		
		
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
    });
    
    //do this again in a bit
    //setTimeout(initiate_geolocation, 15000);
}

function placename(lat, long) {
		var geocoder;
		geocoder = new google.maps.Geocoder();
		var latlng = new google.maps.LatLng(lat, long);
		geocoder.geocode({'latLng': latlng}, function(results, status) {
			$("#address").html(results[0]["formatted_address"])
		})
}
