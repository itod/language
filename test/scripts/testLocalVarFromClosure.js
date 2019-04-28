var x = 0
var foo = null
{
    var i = 47
    foo = sub() {
        print('should be 47, i:' + i)
        x = i
    }
}
foo()
