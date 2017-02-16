var funcs = [];
var x = 0;

for i in range(3) {
    funcs[] = sub () {
        x = i;
        log(i);
    };
}

{
    var i = 47;
    for func in funcs {
        func();
    }
}