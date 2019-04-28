var i = 47
var x = 0

var foo = sub() {
    print('i should be 47, i:' + i)
    x = i
}
foo()
print('x should be 47, x:' + x)
