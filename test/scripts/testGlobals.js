var x = 42
var y = null
try {
    var x = 47
    var tab = globals()
    y = tab['x'];
}
