jQuery(window).ready(function(){  
  initiate_geolocation()	
});  

function initiate_geolocation() {  
    navigator.geolocation.getCurrentPosition(handle_geolocation_query);  
} 

function handle_geolocation_query(position){
	$.ajax({
      url: "api/overview/" + position.coords.latitude + "/" + position.coords.longitude + "/",
      dataType: "json",
      success: function(response) { 
        console.log("success");
        $(response).each(function(index) {
            var level = $(this)[0]["level"]
            var name = $(this)[0]["name"]
            var pressentaionname = $(this)[0]["pressentaionname"]            
            
        });
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
    });
}
