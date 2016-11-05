export function HandleLedSignal(payload) {
  if (payload.type !== '1') {
    console.debug('HandleLedSignal received wrong message type, only accepts type "1", received ' + payload.type);
    return;
  }

  var g1 = document.getElementById('btn_g1');
  var g2 = document.getElementById('btn_g2');
  var y1 = document.getElementById('btn_y1');
  var y2 = document.getElementById('btn_y2');
  var r1 = document.getElementById('btn_r1');
  var r2 = document.getElementById('btn_r2');

  if (payload.body.g1 === 0) {
    g1.className = 'btn'
  }
  else {
    g1.className = 'btn btn-success'
  }

  if (payload.body.g2 === 0) {
    g2.className = 'btn'
  }
  else {
    g2.className = 'btn btn-success'
  }


  if (payload.body.y1 === 0) {
    y1.className = 'btn'
  }
  else {
    y1.className = 'btn btn-warning'
  }

  if (payload.body.y2 === 0) {
    y2.className = 'btn'
  }
  else {
    y2.className = 'btn btn-warning'
  }


  if (payload.body.r1 === 0) {
    r1.className = 'btn'
  }
  else {
    r1.className = 'btn btn-danger'
  }

  if (payload.body.r2 === 0) {
    r2.className = 'btn'
  }
  else {
    r2.className = 'btn btn-danger'
  }

    //.class = 'btn btn-danger';

  console.debug(payload.body);
}
