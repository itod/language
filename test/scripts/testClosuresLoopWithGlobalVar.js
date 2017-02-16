var i = 47;
var x = 0;
var funcs = [];

for i in range(3) {
    funcs[] = sub () {
        x = i;
        log(i); // should log 3
    };
}

for func in funcs {
    func();
}

// x == 3
