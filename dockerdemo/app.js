var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Hello from Christof!');
});

var server = app.listen(8074, function () {
  var host = server.address().address;
  var port = server.address().port;
  console.log('Example app listening at http://' + host + ':' + port);
});
