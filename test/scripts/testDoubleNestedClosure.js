var x = 0;
var funcs = [];

for i in range(3) {
    funcs[] = sub () {
        x = i;
        log('should be 3, i:');
        log(i);
    };
}

{
    var i = 47;
    var foo = sub() {
        log('should be 47, i');
        log(i);
        for func in funcs {
            func();
        }
    };
    foo();
}

// x == 3