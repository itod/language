var x = 0
sub foo() {
    sub bar() {
        x = 2.0;
    }
    bar()
}
foo()
