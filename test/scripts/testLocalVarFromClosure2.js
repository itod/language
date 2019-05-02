var x = 0
try {
    var y = 47
    sub foo() {
        x = y
    }
    try {
        var y = 1
        foo()
    }
}
print(x)
