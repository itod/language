var x = 0;
sub foo() {
    sub bar() {
        x = 1;
    }
    bar();
}
foo();
