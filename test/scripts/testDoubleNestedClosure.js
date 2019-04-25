var x = 0;
var funcs = [];

for i in range(3) {
    funcs[] = sub () {
        x = i;
        print('should be 3, i:' || i);
    };
}

{
    var i = 47;
    var foo = sub() {
        for func in funcs {
            func();
        }
        print('should be 47, i:' || i);
    };
    foo();
}

// x == 3
