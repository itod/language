var name = "eins"
var reason = "zwei"
var line = -1

try {
    assert(0, "FOO BAR BAZ")
} catch e {
    name = e["name"]
    reason = e["reason"]
    line = e["line"]
}
