var x = 0

sub outer() {
    inner()
    sub inner() {
        x = 10
    }
}

outer()
