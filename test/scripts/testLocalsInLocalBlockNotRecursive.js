var x = 42;
var y = 0;
{
    var x = 47;
    {
        var tab = locals(false);
        y = tab['x'];
    }
    
}
