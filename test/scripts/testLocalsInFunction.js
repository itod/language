var a = 'globalX'
var b = null

foo('argX');
sub foo(x) {
    var y = 'localY'
    var tab = locals()
    a = tab['x'];
    b = tab['y'];
}
