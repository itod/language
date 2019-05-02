var i = 47
var x = 0
var foo = null
try {
    foo = sub() {
        print('i should be 47, i: %s' % i)
        x = i
    }
}
foo()
print('x should be 47, x: %s' % x)
