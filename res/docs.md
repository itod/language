## MalerScript Documentation

* [Comments](#comments)
* [Types](#types)
* [String functions](#string-functions)
* [Date functions](#date-functions)
* [Number functions](#number-functions)
* [Boolean functions](#boolean-functions)

### <a name="comments"></a>Comments

Comments may be used to provide informative annotation for an expression. Comments are lexical constructs only, and do not affect expression processing.

Comments are strings, delimited by the symbols `/*` and `*/` or `//`. The former may span multiple lines, the latter may not. Comments may be nested.

A comment may be used anywhere ignorable whitespace is allowed.

The following is an example of a multi-line comment:

    /* Houston, 
    we have a problem */

And a single-line:

    // TODO

### <a name="types"></a>Types

MalerScript includes six (6) concrete data types: Boolean, Number, String, Array, Dictionary and Function, and one abstract data type: Object.

<a name="boolean"></a>**Type:** **Boolean**

An object of type boolean can have one of two values, true and false.

    true

    false

<a name="number"></a>**Type:** **Number**

A number represents a floating-point number. A number can have any double-precision 64-bit format [IEEE 754](http://www.w3.org/TR/xpath/#IEEE754) value.

The numeric operators convert their operands to numbers as if by calling the [`Number`](#fn-number) function.

    42

    3.14

    1.6E-35

<a name="string"></a>**Type:** **String**

Strings consist of a sequence of zero or more [Unicode](http://www.unicode.org/ "Unicode Consortium") characters.

    'Evil will always triumph, because good is dumb.'    

    "It's not a tumor!"

<a name="array"></a>**Type:** **Array**

Arrays are an ordered sequence of other objects of any type (including other arrays).

    [false, 'eins', 'zwei', 'drei', 4, 5.0]

    [] // an empty array

<a name="dictionary"></a>**Type:** **Dictionary**

Dictionaries are name/value pairs that offer efficient storage and lookup by name.

    {'name': 'Todd', 'age':39, 'male': true}

    {} // an empty dictionary

<a name="function"></a>**Type:** **Function**

Functions are callable portions of a program which can return a value. In MalerScript, all functions are objects.

    sub getName(dict) {
        var name = dict['first_name'] || " " || dict['last_name']
        return name
    }

<a name="object"></a>**Type:** **Object**

All other data types are a subclass of the root, abstract data type `Object`. You cannot instantiate an object of type `Object`, so it is only useful to know about in the context of argument types to functions.

### <a name="boolean-functions"></a>Boolean Functions

Boolean Functions

<a name="fn-boolean"></a>**Function:** *Boolean* **Boolean**(*object*)

The `Boolean` function converts its argument to a boolean as follows:

* a `Number` is true if and only if it is neither positive or negative zero nor NaN
* a `String` is true if and only if its count is non-zero (contains one or more characters)
* an `Array` is true if and only if its count is non-zero (contains one or more items)
* a `Dictionary` is true if and only if its count is non-zero (contains one or more name/value pairs)
* a `Function` is always true

### <a name="string-functions"></a>String Functions

<a name="fn-string"></a>**Function:** *String* **String**(*Object?*)

The `String` function converts an object to a string as follows:

* A number is converted to a string as follows:
    * NaN is converted to the string `NaN`
    * positive zero is converted to the string `0`
    * negative zero is converted to the string `0`
    * positive infinity is converted to the string `Infinity`
    * negative infinity is converted to the string `-Infinity`
    * if the number is an integer, the number is represented in decimal form as a Number with no decimal point and no leading zeros, preceded by a minus sign (-) if the number is negative
    * otherwise, the number is represented in decimal form as a Number including a decimal point with at least one digit before the decimal point and at least one digit after the decimal point, preceded by a minus sign (-) if the number is negative; there must be no leading zeros before the decimal point apart possibly from the one required digit immediately before the decimal point; beyond the one required digit after the decimal point there must be as many, but only as many, more digits as are needed to uniquely distinguish the number from all other IEEE 754 numeric values.
  
* The boolean false value is converted to the string `false`. The boolean true value is converted to the string `true`.
* Arrays are converted into a string beginning with `[`, followed by the string representation of each item in the array (as if the `String` function were called on it), each item – except the last – followed by a comma and a single space character `, `, and then finally a `]`.
* Dictionaries are converted into a string beginning with `{`, followed by the string representation of each name/value pair in the dictionary (as if the `String` function were called on them) separated by colon and a space character `: `, each pair – except the last – followed by a comma and a single space character `, `, and then finally a `}`.
* TODO Subroutine
* If the argument is omitted, it returns the empty string.

<a name="fn-string-matches"></a>**Function:** *String* **matches**(*String input*, *String pattern*, *String? flags*)

The `matches` function returns true if `input` matches the regular expression supplied as `pattern` as influenced by the value of `flags`, if present; otherwise, it returns false.

The available flags are:
* `s`: If present, the match operates in "dot-all" mode. (Perl calls this the single-line mode.)
* `m`: If present, the match operates in multi-line mode.
* `i`: If present, the match operates in case-insensitive mode.
* `x`: If present, whitespace characters (`#x9`, `#xA`, `#xD` and `#x20`) in the regular expression are removed prior to matching with one exception: whitespace characters within character class expressions are not removed. This flag can be used, for example, to break up long regular expressions into readable lines.

<a name="fn-string-replace"></a>**Function:** *String* **replace**(*String* input, *String* pattern, *String* replacement, *String?* flags)

The `replace` function returns the string that is obtained by replacing each non-overlapping substring of `input` that matches the given regular expression supplied as `pattern` with an occurrence of the `replacement` string.

The `flags` argument is interpreted in the same manner as for the [`matches`](#fn-string-matches) function.

<a name="fn-string-compare"></a>**Function:** *Number* **compare**(*String*, *String*)

The `compare` function returns -1, 0, or 1, depending on whether the value of the first argument is respectively less than, equal to, or greater than the value of the second argument, according to the rules of lexical string comparison.

<a name="fn-string-contains"></a>**Function:** *Number* **contains**(*String* needle, *String* haystack)

The `contains` function returns 0 if the first argument string does not contain the second argument string. If the first argument string *does* contain the second argument string, the index of the second string within the first string is returned. Recall that all indexes in MalerScript are 1-based, not 0-based.

<a name="fn-string-count"></a>**Function:** *Number* **count**(*String*)

The `count` returns the number of characters in the argument string.

<a name="fn-string-trim"></a>**Function:** *String* **trim**(*String*)

The `trim` function returns the argument string with leading and trailing whitespace removed. Whitespace characters are the same as those allowed by the S production in XML (newline `#xA`, carriage return `#xD`, space `#x20`, and tab `#x9`).

<a name="fn-string-lowercase"></a>**Function:** *String* **lowercase**(*String*)

The `lowercase` function returns the argument string as a lowercase string.

<a name="fn-string-uppercase"></a>**Function:** *String* **uppercase**(*String*)

The `uppercase` function returns the argument string as a uppercase string.

### <a name="number-functions"></a>Number Functions

<a name="fn-number"></a>**Function:** *Number* **Number**(*Object?*)

The `Number` function converts its argument to a number as follows:

* a string that consists of optional whitespace followed by an optional minus sign followed by a Number followed by whitespace is converted to the IEEE 754 number that is nearest (according to the IEEE 754 round-to-nearest rule) to the mathematical value represented by the string; any other string is converted to NaN
* boolean true is converted to 1; boolean false is converted to 0
* a node-set is first converted to a string as if by a call to the [`string`](#fn-string) function and then converted in the same way as a string argument
* an object of a type other than the four basic types is converted to a number in a way that is dependent on that type

If the argument is omitted, it returns `0`.

<a name="fn-number-abs"></a>**Function:** *Boolean* **isNaN**(*Number*)

The `isNaN` function returns true if the argument is NaN. Otherwise, false. Note this is the only way to test for NaN as the expression `NaN == NaN` returns false.s

<a name="fn-number-random"></a>**Function:** *Number* **random**(*Number* low, *Number?* high)

The `random` function returns a random number between the low and high arguments. If the high argument is omitted, then the first argument becomes the high bound and zero is the lower bound.

<a name="fn-number-abs"></a>**Function:** *Number* **abs**(*Number*)

The `abs` function returns the absolute value of the argument.

<a name="fn-number-floor"></a>**Function:** *Number* **floor**(*Number*)

The `floor` function returns the largest (closest to positive infinity) number that is not greater than the argument and that is an integer.

<a name="fn-number-ceil"></a>**Function:** *Number* **ceil**(*Number*)

The `ceil` function returns the smallest (closest to negative infinity) number that is not less than the argument and that is an integer.

<a name="fn-number-round"></a>**Function:** *Number* **round**(*Number*)

The `round` function returns the number that is closest to the argument and that is an integer. If there are two such numbers, then the one that is closest to positive infinity is returned. If the argument is NaN, then NaN is returned. If the argument is positive infinity, then positive infinity is returned. If the argument is negative infinity, then negative infinity is returned. If the argument is positive zero, then positive zero is returned. If the argument is negative zero, then negative zero is returned. If the argument is less than zero, but greater than or equal to -0.5, then negative zero is returned.

**NOTE:** For these last two cases, the result of calling the [`round`](#fn-number-round) function is not the same as the result of adding 0.5 and then calling the [`floor`](#fn-number-floor) function.

<a name="fn-number-sqrt"></a>**Function:** *Number* **sqrt**(*Number*)

The `sqrt` function returns the square root of the argument.

<a name="fn-number-pow"></a>**Function:** *Number* **pow**(*Number* base, *Number* power)

The `pow` function returns base raised to the power power.

<a name="fn-number-max"></a>**Function:** *Number* **max**(*Number*, *Number*)

The `max` function returns the argument with the greatest value.

<a name="fn-number-min"></a>**Function:** *Number* **min**(*Number*, *Number*)

The `max` function returns the argument with the least value.


### <a name="trig-functions"></a>Trigonometry Functions

<a name="fn-number-degrees"></a>**Function:** *Number* **degrees**(*Number* radians)

The `degrees` function returns the radians argument as degrees.

<a name="fn-number-radians"></a>**Function:** *Number* **radians**(*Number* degrees)

The `radians` function returns the degrees argument as radians.

<a name="fn-number-log"></a>**Function:** *Number* **log**(*Number*)

<a name="fn-number-acos"></a>**Function:** *Number* **acos**(*Number*)

<a name="fn-number-asin"></a>**Function:** *Number* **asin**(*Number*)

<a name="fn-number-atan"></a>**Function:** *Number* **atan**(*Number*)

<a name="fn-number-atan2"></a>**Function:** *Number* **atan2**(*Number*, *Number*)

<a name="fn-number-cos"></a>**Function:** *Number* **cos**(*Number*)

<a name="fn-number-sin"></a>**Function:** *Number* **sin**(*Number*)

<a name="fn-number-tan"></a>**Function:** *Number* **tan**(*Number*)

### <a name="array-functions"></a>Array Functions

<a name="fn-array-sum"></a>**Function:** *Number* **sum**(*Array*)

The `sum` function returns the sum, for each item in the array argument, of the result of converting the item to a number.

<a name="fn-array-contains"></a>**Function:** *Number* **contains**(*Array* haystack, *Object* needle)

The `contains` function returns a number equal to the position of the needle argument in the haystack argument. If needle is not present in haystack, zero is returned. Recall that all indexes in MalerScript are 1-based, not 0-based.

<a name="fn-array-count"></a>**Function:** *Number* **count**(*Array*)

The `count` function returns the number of items in the argument array.

<a name="fn-array-range"></a>**Function:** *Array* **range**(*Number?* start, *Number* stop, *Number?* step)

The `range` function returns an array of numbers from start (which is zero if the start argument is not explicitly included) to stop (*inclusive*). If the optional step argument is included, it will be used as the difference between each number in the result array.

<a name="fn-array-map"></a>**Function:** *Array* **map**(*Array*, *Function*)

<a name="fn-array-filter"></a>**Function:** *Array* **filter**(*Array*, *Function*)

### <a name="dict-functions"></a>Dictionary Functions

<a name="fn-dict-map"></a>**Function:** *Dictionary* **map**(*Dictionary*, *Function*)

<a name="fn-dict-filter"></a>**Function:** *Dictionary* **filter**(*Dictionary*, *Function*)

<a name="fn-dict-locals"></a>**Function:** *Dictionary* **locals**()

The `locals` function returns all variables currently declared in the nearest local context as a Dictionary of name/value pairs.

<a name="fn-dict-globals"></a>**Function:** *Dictionary* **globals**()

The `globals` function returns all variables currently declared in the global context as a Dictionary of name/value pairs.
