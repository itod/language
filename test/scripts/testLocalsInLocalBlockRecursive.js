var x = 42
var y = 0
try {
    var x = 47
    try {
        var tab = locals(true)
        y = tab['x'];
    }
    
}
