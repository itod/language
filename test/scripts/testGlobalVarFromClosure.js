var i = 47
var x = 0

var foo = sub() {
    log('i should be 47, i:' || i)
    x = i
}
foo()
log('x should be 47, x:' || x)
