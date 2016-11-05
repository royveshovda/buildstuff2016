export function HandleButtonSignal(payload) {
  if (payload.type !== '2') {
    console.debug('HandleButtonSignal received wrong message type, only accepts type "3", received ' + payload.type);
    return;
  }

  var temparatureButton = document.getElementById('btn_temparature');
  var humidityButton = document.getElementById('btn_humidity');

  if (payload.body.temperature_button === 0) {
    //temparatureButton.className = 'btn btn-default'
  }
  else {
    //temparatureButton.className = 'btn btn-success'
  }

  console.debug(payload.body);
}
