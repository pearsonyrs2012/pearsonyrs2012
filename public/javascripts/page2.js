jQuery(window).ready(function(){  
  initiate_geolocation()	
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
					$(imageid).src = "images/icons/high.png";
					$(imageid).alt = "High Level";
				}else{
					$(imageid).src = "images/icons/low.png";
					$(imageid).alt = "Low Level";
            }
			
			}

        });
		
		
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
			  //var name = $(this)[0]["name"]
			  //var imageid = '#' + name + 'levelimg'
			  		//$(imageid).src = "images/icons/help.png";
					//$(imageid).alt = "Error";
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
