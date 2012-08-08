jQuery(window).ready(function(){  
    // jQuery("#btnInit").click(initiate_geolocation);
initiate_geolocation()	
});  

function initiate_geolocation() {  
    navigator.geolocation.getCurrentPosition(handle_geolocation_query);  
} 

function handle_geolocation_query(position){  
    alert('Lat: ' + position.coords.latitude + ' ' +  
          'Lon: ' + position.coords.longitude);
	$.ajax({
		url: "api/overview/" + position.coords.latitude + "/" + position.coords.longitude + "/",
		dataType: "json",
		success: function(response) { console.log(response)		;
		},
		error: function(xhr,text,errort) {console.log(xhr);
										console.log(text);
										console.log(errort);
											}
	});
}
