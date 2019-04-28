var i = 47
var x = 0
var funcs = []

for i in range(3) {
    funcs[] = sub () {
        x = i
        print('i should be 3, i:' + i)
    }
}

for func in funcs {
    func()
}

// x == 3
