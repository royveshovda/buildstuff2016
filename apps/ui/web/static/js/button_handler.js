export function HandleButtonSignal(payload) {
  if (payload.type !== '2') {
    console.debug('HandleButtonSignal received wrong message type, only accepts type "3", received ' + payload.type);
    return;
  }

  let temperatureButton = document.getElementById('btn_temparature');
  let humidityButton = document.getElementById('btn_humidity');

  if (payload.body.button_updated === 'b1') {
    if (payload.body.temperature_button === 'up') {
      // setTimeout(function () {
      //     temperatureButton.className = 'btn btn-default'
      // }, 1000);

      temperatureButton.className = 'btn btn-default'
    }

    if (payload.body.temperature_button === 'down') {
      // setTimeout(function () {
      //     temperatureButton.className = 'btn btn-default'
      // }, 1000);

      temperatureButton.className = 'btn btn-danger'
    }
  }

  if (payload.body.button_updated === 'b2') {
    if (payload.body.humidity_button === 'up') {
      // setTimeout(function () {
      //     humidityButton.className = 'btn btn-default'
      // }, 1000);

      humidityButton.className = 'btn btn-default'
    }

    if (payload.body.humidity_button === 'down') {
      // setTimeout(function () {
      //     humidityButton.className = 'btn btn-default'
      // }, 1000);

      humidityButton.className = 'btn btn-danger'
    }
  }



}
