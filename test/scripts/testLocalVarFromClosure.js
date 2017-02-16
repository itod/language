var x = 0;
{
    var i = 47;
    var foo = sub() {
        log('should be 47:');
        log(i);
        x = i;
    };
    foo();
}
