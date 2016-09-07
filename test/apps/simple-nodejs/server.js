var express = require('express');
var app = express();

app.get('/', function (req, res) {
  res.send('Node.js - Express - Hello World!');
});

var server = app.listen(8080, '0.0.0.0', function () {
  var host = server.address().address;
  var port = server.address().port;

  console.log('Example app listening at http://%s:%s', host, port);
});
