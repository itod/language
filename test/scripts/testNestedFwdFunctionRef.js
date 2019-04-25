var x = 0;
foo();
sub foo() {
    var baz = bar;
    baz();
    sub bar() {
        x = 3.0;
    }
}
