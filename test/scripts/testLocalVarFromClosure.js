var x = 0;
var foo = null;
{
    var i = 47;
    foo = sub() {
        log('should be 47:');
        log(i);
        x = i;
    };
}
foo();