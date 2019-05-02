var x = 0
if 1 {
    var y = 47
    sub foo() {
        x = y
    }
    if 1 {
        var y = 1
        foo()
    }
}
print(x)
