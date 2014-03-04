
var yaguar = require('./yaguar');

yaguar.getCategorias(function (err, data) {
    if (err)
        console.log(err);
    else
        console.log(data);
});