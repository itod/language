var x = 0

sub outer() {

    sub inner() {
        x = 10
    }
    inner()
}

outer()
