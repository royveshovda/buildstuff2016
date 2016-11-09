export function HandleTemperatureSignal(payload) {
  if (payload.type !== '3') {
    console.debug('HandleTemperatureSignal received wrong message type, only accepts type "3", received ' + payload.type);
    return;
  }

  let temperatureElement = document.getElementById('div_temperature');
  temperatureElement.innerText = normalizeTemperature(payload.body.temperature);
  temperatureElement.className = "alert-info";
  setTimeout(function () {
      temperatureElement.className = ""
  }, 1000);


  let humidityElement = document.getElementById('div_humidity');
  humidityElement.innerText = normalizeHumidity(payload.body.humidity);
  humidityElement.className = "alert-info";

  setTimeout(function () {
      humidityElement.className = ""
  }, 1000);

  console.debug(payload.body);
}

function normalizeTemperature(temperature){
  return Math.round(temperature);
}

function normalizeHumidity(humidity){
  return Math.round(humidity);
}
