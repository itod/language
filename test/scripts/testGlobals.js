var x = 42;
var y = null;
{
    var x = 47;
    var tab = globals();
    y = tab['x'];
}
