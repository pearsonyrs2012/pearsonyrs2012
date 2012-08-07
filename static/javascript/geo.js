jQuery(window).ready(function(){  
    jQuery("#btnInit").click(initiate_geolocation);  
});  

function initiate_geolocation() {  
    navigator.geolocation.getCurrentPosition(handle_geolocation_query);  
} 

function handle_geolocation_query(position){  
    //alert('Lat: ' + position.coords.latitude + ' ' +  
      //    'Lon: ' + position.coords.longitude); 
	  $('#coord').html("You are at latitude: " + position.coords.latitude + ' ' +  'Longitude: ' + position.coords.longitude)
			drawmap(position.coords.latitude, position.coords.longitude)
}

function drawmap(lat, long) {
        var mapOptions = {
          zoom: 16,
          center: new google.maps.LatLng(lat, long),
          mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById('map_canvas'),
                                      mapOptions);

        var image = 'images/map-pointer.png';
        var myLatLng = new google.maps.LatLng(lat, long);
        var beachMarker = new google.maps.Marker({
            position: myLatLng,
            map: map,
            icon: image
        });
      }