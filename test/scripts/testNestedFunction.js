var x = 0
foo()
sub foo() {
    bar()
    sub bar() {
        x = 1;
    }
}
