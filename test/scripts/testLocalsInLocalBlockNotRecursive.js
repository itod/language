var x = 42
var y = 0
if 1 {
    var x = 47
    if 1 {
        var tab = locals(false)
        y = tab['x'];
    }
    
}
