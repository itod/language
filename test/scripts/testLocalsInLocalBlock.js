var x = 42
var y = 0
try {
    var x = 47
    var tab = locals()
    y = tab['x'];
}
