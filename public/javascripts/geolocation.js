jQuery(window).ready(function(){ 
	initiate_geolocation()
	});
	
function initiate_geolocation() {  
    navigator.geolocation.getCurrentPosition(
											handle_geolocation_query,
											function () { 
														console.log ('could not get position'); 
														alert('could not establish position');
														setTimeout(initiate_geolocation, 15000);							
														},
												{enableHighAccuracy: false, timeout: 6000}
											);
}
function handle_geolocation(position) {
    //do this again in a bit
    setTimeout(initiate_geolocation, 15000);
placename(position.coords.latitude, position.coords.longitude);
handle_geolocation_query(position);
}
function placename(lat, long) {
		var geocoder;
		geocoder = new google.maps.Geocoder();
		var latlng = new google.maps.LatLng(lat, long);
		geocoder.geocode({'latLng': latlng}, function(results, status) {
			$("#address").html(results[0]["formatted_address"])
		})
}
