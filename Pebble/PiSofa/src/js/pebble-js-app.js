var baseUrl = "0.0.0.0";

function sendRequest(url) {
	//var response;
	var req = new XMLHttpRequest();
	// build the GET request
	req.open('GET', url, true);
	req.onreadystatechange = function(e) {
		// req.readyState
		// 0: request not initialized 
		// 1: server connection established
		// 2: request received 
		// 3: processing request 
		// 4: request finished and response is ready
		if (req.readyState == 0) {
			Pebble.showSimpleNotificationOnPebble("ERROR 2", "Error code from HTTP request was " + req.status.toString());
        	console.log("Request returned error code " + req.status.toString());
		} else if (req.readyState == 4) {
			if(req.status != 200) {
				Pebble.showSimpleNotificationOnPebble("ERROR 1", "Error code from HTTP request was " + req.status.toString());
        		console.log("Request returned error code " + req.status.toString());
			}
		}
    }
	req.send(null);
}


Pebble.addEventListener("ready",
	function(e) {
    	console.log("JavaScript app ready and running!");
		var savedSettings = localStorage.getItem('piSofaConfig');
		var configuration = JSON.parse(savedSettings);
		console.log("Configuration API: " + configuration.api);
		baseUrl = configuration.api;
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

Pebble.addEventListener('showConfiguration', function(e) {
	Pebble.openURL('http://oncloudvirtual.com/pisofa.html')
});

Pebble.addEventListener("webviewclosed",
  function(e) {
	  console.log("Configuration window returned: " + e.response);
	  var configuration = JSON.parse(e.response);
	  console.log("Configuration window returned: " + configuration.api);
	  baseUrl = configuration.api;
	  localStorage.setItem('piSofaConfig', e.response);
  }
);