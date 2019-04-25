var a = 'globalX';
var b = null;
var c = null;

var foo = sub(x) {
    var y = 'localY';
    var tab = locals();
    a = tab['x'];
    b = tab['y'];
    c = tab['a'];
};

foo('argX');
