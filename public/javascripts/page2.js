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
          
            // get values from response
            var level = $(this)[0]["level"]
            var name = $(this)[0]["name"]
            var pressentaionname = $(this)[0]["pressentaionname"]
            
            //add to page
            li = $('<li></li>')
			if(level >= 0.5){
				li.append('<p>High</p>');
				if (name == "pizza") {
					$("#testlevelimg").src = "images/icons/high.png";
					$("#testlevelimg").alt = "High Level";
				}
			}
            }else{
				li.append('<p>Low</p>'); 
				if (name == "pizza") {
					$("#testlevelimg").src = "images/icons/low.png";
					$("#testlevelimg").alt = "Low Level";
				}
            }
            li.append(name)            
            $("#test").append(li)
			//set table items

        });
		
		
      },
      error: function(xhr,text,errort) {console.log(xhr);
              console.log("failed");
              console.log(text);
              console.log(errort);
            }
    });
}
