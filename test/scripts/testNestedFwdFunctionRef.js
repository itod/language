var x = 0
sub foo() {
    sub bar() {
        x = 3.0;
    }
    var baz = bar;
    baz()
}
foo()
