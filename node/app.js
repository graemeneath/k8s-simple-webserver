const express = require('express')
const bodyParser = require('body-parser');

const app = express()
app.use(bodyParser.urlencoded({ extended: true }));
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

// -d 'name=<name>&info=<info> /info/store
app.post('/store', function (req, res) {
  name=req.body.name;
  info=req.body.info;
  fs = require('fs');
  fs.writeFile('/pvc/store/'+name, info, function (err) {
    if (err) {
      console.log(err);
      res.send('error');
    }
    res.send('ok');
  })
})

// /info/store?name=<name>
app.get('/store', function (req, res) {
  name=req.query.name
  fs = require('fs')
  fs.readFile('/pvc/store/'+name, 'utf8', function (err,data) {
      if (err) {
          console.log(err);
          res.send('');
      }
      res.send(data);
  });  
})

app.listen(port, () => console.log(`Node express service listening`))
