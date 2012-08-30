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


function handle_geolocation_query(position){
  

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
					$(imageid).attr("src","images/icons/high128.png");
					$(imageid).attr("alt","High Level");
				}else{
					$(imageid).attr("src","images/icons/low128.png");
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
}

