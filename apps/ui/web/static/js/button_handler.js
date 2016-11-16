export function HandleButtonSignal(payload) {
  if (payload.type !== '2') {
    console.debug('HandleButtonSignal received wrong message type, only accepts type "3", received ' + payload.type);
    return;
  }

  let temperatureButton = document.getElementById('btn_temparature');
  let humidityButton = document.getElementById('btn_humidity');

  if (payload.body.button_updated === 'b1') {
    if (payload.body.temperature_button === 'up') {
      temperatureButton.className = 'btn btn-default'
    }

    if (payload.body.temperature_button === 'down') {
      temperatureButton.className = 'btn btn-danger'
    }
  }

  if (payload.body.button_updated === 'b2') {
    if (payload.body.humidity_button === 'up') {
      humidityButton.className = 'btn btn-default'
    }

    if (payload.body.humidity_button === 'down') {
      humidityButton.className = 'btn btn-danger'
    }
  }
}
