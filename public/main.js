$(document).ready(function() {

var posOptions = {
	enableHighAccuracy: true,
	desiredAccuracy: 1650,
    // timeout sets the time limit when looking for location(set to 5 secs)
	timeout: 5000,
	maximumAge: 0
}

if (top.location.pathname === '/home') {
$(function getLocation() {
	if(navigator.geolocation) {
		navigator.geolocation.watchPosition(showPosition, showError, posOptions);
	}
  })
}

function showPosition(pos) {
	var crd = pos.coords;
    lat = pos.coords.latitude;
    lon = pos.coords.longitude;
    console.log(lat, lon);
	console.log(crd);
    
    setValues(lat, lon);
}
// injection into form
// called in showPosition func because the geolocation values
// need to be found first before everything else loads/saves data
function setValues(lat, lon){
    // console.log("function fired");
    $("#lat").val(lat);
    $("#lon").val(lon);        
}

function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            console.log("User denied the request for Geolocation.")
            break;
        case error.POSITION_UNAVAILABLE:
            console.log("Location information is unavailable.")
            break;
        case error.TIMEOUT:
            console.log("The request to get user location timed out.")
            break;
        case error.UNKNOWN_ERROR:
            console.log("An unknown error occurred.")
            break;
    }
}

});