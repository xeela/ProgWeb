<!-- chiamando getLocation()mi restituisce le coordinate da usare -->
<script>
var x = document.getElementById("demo");

function getLocation() {
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(showPosition);
    } else { 
        x.innerHTML = "Geolocation is not supported by this browser.";
    }
}

function showPosition(position) {
    x.innerHTML = "Latitude: " + position.coords.latitude + 
    "<br>Longitude: " + position.coords.longitude;
}
    
function showError(error) {
    switch(error.code) {
        case error.PERMISSION_DENIED:
            x.innerHTML = "Non hai autorizzato la geolocalizzazione."
            break;
        case error.POSITION_UNAVAILABLE:
            x.innerHTML = "La posizione non è disponibile."
            break;
        case error.TIMEOUT:
            x.innerHTML = "Il timeout é scaduto."
            break;
        case error.UNKNOWN_ERROR:
            x.innerHTML = "Errore sconosciuto."
            break;
    }
}

</script>
