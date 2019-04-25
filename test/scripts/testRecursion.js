sub sumr(a, b) {
    if 0==b {
        return a;
    } else {
        return 1 + sumr(a, b-1);
    }
}

sub sumi(a, b) {
    if 0==b {
        return a;
    } else {
        return sumi(a+1, b-1);
    }
}

var x = sumr(10,2);
var y = sumi(10,3);
