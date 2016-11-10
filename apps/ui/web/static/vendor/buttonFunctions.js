function requestTemperatureClick(btn) {
  callHardware();
}

function requestHumidityClick(btn) {
  callHardware();
}

function requestLedClick(id){
  var fullId = 'btn_' + id;

  var button = document.getElementById(fullId);

  if (button.className === 'btn') {
    callLedApi(id, 1);
  }
  else {
    callLedApi(id, 0);
  }

}

function callHardware() {
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
      //alert(request.responseText);
    }
  }

  request.open('GET', '/api/buttons', true);
  request.send(null);
}

function callLedApi(id, state){
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState == 4 && request.status == 200) {
      //alert(request.responseText);
    }
  }

  request.open('POST', '/api/leds/' + id + '/' + state, true);
  request.send(null);
}
