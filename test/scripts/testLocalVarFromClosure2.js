var x = 0
{
    var y = 47
    sub foo() {
        x = y
    }
    {
        var y = 1
        foo()
    }
}
print(x)
