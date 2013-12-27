var baseUrl = "sofa.cooper.local";

function sendRequest(url) {
	//var response;
	var req = new XMLHttpRequest();
	// build the GET request
	req.open('GET', url, true);
	
	req.onload = function(e) {
		if (req.readyState == 4) {
			if(req.status != 200) {
				Pebble.showSimpleNotificationOnPebble("ERROR", "Error code from HTTP request was " + req.status.toString());
        		console.log("Request returned error code " + req.status.toString());
			}
		} else {
			Pebble.showSimpleNotificationOnPebble("ERROR", "Error code from HTTP request was " + req.status.toString());
        	console.log("Request returned error code " + req.status.toString());
      	}
    }
	
	req.send(null);
}


Pebble.addEventListener("ready",
  function(e) {
    console.log("JavaScript app ready and running!");
  }
);

Pebble.addEventListener("appmessage",
  function(e) {
	  var url = "http://" + baseUrl + "/";
	  switch(e.payload.position)
	  {
		  case 0:
			  url += "moveToUp/" + e.payload.sofa
			  break;
		  case 1:
			  url += "moveToFeet/" + e.payload.sofa
			  break;
		  case 2:
			  url += "moveToFlat/" + e.payload.sofa
			  break;
		  case 3:
			  url += "parentalMode"
			  break;
	  }
	  console.log(url);
	  sendRequest(url);
  }
);