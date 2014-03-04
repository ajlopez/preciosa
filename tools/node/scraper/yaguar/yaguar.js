
var http = require('http');

function getPage(url, cb) {
    http.get(url, function(res) {
        var body = '';

        res.on('data', function(chunk) {
            body += chunk.toString();
        });

        res.on('end', function() {
            cb(null, body);
        });
    }).on('error', function(e) {
        console.log('error');
        cb(e, null);
    });    
}

function getCategorias(cb) {
    getPage("http://www.yaguar.com/frontendSP/asp/home.asp?IframeSrc=iframe_Marcas.asp#", getData);
    
    function getData(err, page) {
        if (err) {
            cb(err, null);
            return;
        }
        
        var start = 0;
        var tosearch = 'javascript:OpenCloseDeptos(';
        
        for (var position = page.indexOf(tosearch, start); position >= 0; position = page.indexOf(tosearch, start)) {
            start = position + 10;
            var position2 = page.indexOf(')', position);
            var id = page.substring(position + tosearch.length, position2);
            console.log('id', id);
            var position3 = page.indexOf('>', position2);
            var position4 = page.indexOf('<', position3);
            var name = page.substring(position3 + 1, position4).trim();
            console.log('name', name);
        }
        
        cb(null, 'thanks');
    }
}

module.exports = {
    getCategorias: getCategorias
};