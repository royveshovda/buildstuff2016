function requestTemperatureClick(btn) {
  callHardware();
}

function requestHumidityClick(btn) {
  callHardware();
}

function callHardware() {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
      //alert(request.responseText);
    }
  }

  request.open('GET', 'api/buttons', true);
  request.send(null);
}
