var x = 42
var y = 0
if 1 {
    var x = 47
    var tab = locals()
    y = tab['x'];
}
