export function HandleTemperatureSignal(payload) {
  if (payload.type !== '3') {
    console.debug('HandleTemperatureSignal received wrong message type, only accepts type "3", received ' + payload.type);
    return;
  }

  document.getElementById('div_temperature').innerText = normalizeTemperature(payload.body.temperature);
  document.getElementById('div_humidity').innerText = normalizeHumidity(payload.body.humidity);
  //$('#div_temperature').html(payload.body.temperature);

  console.debug(payload.body);
}

function normalizeTemperature(temperature){
  return Math.round(temperature);
}

function normalizeHumidity(humidity){
  return Math.round(humidity);
}
