const express = require('express')
const app = express()
const port = 3000

app.get('/', function (req, res) {
    fs = require('fs')
    fs.readFile('/pvc/dashboard/nolimits.json', 'utf8', function (err,data) {
        if (err) {
            return console.log(err);
        }
        res.send(data);
    });
})

app.listen(port, () => console.log(`Node express service listening`))
