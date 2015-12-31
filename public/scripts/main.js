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
            //console.log(lat_lon)
    	}
      })
    }
    var lat_lon = [];
    function showPosition(pos) {
    	var crd = pos.coords;
        lat = pos.coords.latitude;
        lon = pos.coords.longitude;
        
        setValues(lat, lon);
        lat_lon = [ lat, lon, crd]
        return lat_lon;
        
    }
    // injection into form on home page submit
    // called in showPosition func because the geolocation values
    // need to be found first before everything else loads/saves data
    function setValues(lat, lon){
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
            setTimeout(function() { //ajax call
            $.get("/home/location", {
                // url params key=val
                lat: lat_lon[0],
                lon: lat_lon[1]
                // data is what's returned
            }, function(data) {
                //Used 'debugger' to access variable data
                $('#post_radius').html(data);
            })
        }, 5000);
});