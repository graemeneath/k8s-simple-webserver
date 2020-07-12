const express = require('express')
const app = express()
const port = 3000

app.get('/track', function (req, res) {
  fs = require('fs')
  fs.readFile('/pvc/dashboard/nolimits.json', 'utf8', function (err,data) {
      if (err) {
          console.log(err);
          res.send('{}');
      }
      res.send(data);
  });
})

app.get('/finance', function (req, res) {
  fs = require('fs')
  fs.readFile('/pvc/dashboard/finance.json', 'utf8', function (err,data) {
      if (err) {
          console.log(err);
          res.send('{}');
      }
      res.send(data);
  });
})

app.listen(port, () => console.log(`Node express service listening`))
