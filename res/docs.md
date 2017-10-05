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

MalerScript includes six (6) data types: Boolean, Number, String, Array, Dictionary and Function.

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

### <a name="string-functions"></a>String Functions

<a name="fn-string"></a>**Function:** *String* **String**(*object?*)

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

**NOTE:** The [`String`](#fn-string) function is not intended for converting numbers into strings for presentation to users. The [`format-number`](#fn-format-number) function provides this functionality.

<a name="fn-matches"></a>**Function:** *String* **matches**(*String input*, *String pattern*, *String? flags*)

The `matches` function returns true if `input` matches the regular expression supplied as `pattern` as influenced by the value of `flags`, if present; otherwise, it returns false.

The available flags are:
* `s`: If present, the match operates in "dot-all" mode. (Perl calls this the single-line mode.)
* `m`: If present, the match operates in multi-line mode.
* `i`: If present, the match operates in case-insensitive mode.
* `x`: If present, whitespace characters (`#x9`, `#xA`, `#xD` and `#x20`) in the regular expression are removed prior to matching with one exception: whitespace characters within character class expressions are not removed. This flag can be used, for example, to break up long regular expressions into readable lines.

<a name="fn-replace"></a>**Function:** *String* **replace**(*String input*, *String pattern*, *String replacement*, *String? flags*)

The `replace` function returns the string that is obtained by replacing each non-overlapping substring of `input` that matches the given regular expression supplied as `pattern` with an occurrence of the `replacement` string.

The `flags` argument is interpreted in the same manner as for the [`matches`](#fn-matches) function.

<a name="fn-compare"></a>**Function:** *String* **compare**(*String*, *String*)

The `compare` function returns -1, 0, or 1, depending on whether the value of the first argument is respectively less than, equal to, or greater than the value of the second argument, according to the rules of lexical string comparison.

<a name="fn-contains"></a>**Function:** *Boolean* **contains**(*String*, *String*)

The `contains` function returns true if the first argument string contains the second argument string, and otherwise returns false.

<a name="fn-count"></a>**Function:** *Number* **count**(*sequence*)

The `count` returns the number of items in the sequence. If the sequence is a string, the result is the number of characters. If the sequence is an array, the result is the number of items in the array. If the sequence is a dictionary, the result is the number of name/value pairs in the dictionary.

<a name="fn-trim"></a>**Function:** *String* **trim**(*String?*)

The `trim` function returns the argument string with leading and trailing whitespace removed. Whitespace characters are the same as those allowed by the S production in XML (newline `#xA`, carriage return `#xD`, space `#x20`, and tab `#x9`).

<a name="fn-lowercase"></a>**Function:** *String* **lower-case**(*String*)

The `lower-case` function returns the argument string as a lowercase string.

<a name="fn-uppercase"></a>**Function:** *String* **upper-case**(*String*)

The `upper-case` function returns the argument string as a uppercase string.

### <a name="number-functions"></a>Number Functions

<a name="fn-number"></a>**Function:** *Number* **Number**(*object?*)

The `Number` function converts its argument to a number as follows:

* a string that consists of optional whitespace followed by an optional minus sign followed by a Number followed by whitespace is converted to the IEEE 754 number that is nearest (according to the IEEE 754 round-to-nearest rule) to the mathematical value represented by the string; any other string is converted to NaN
* boolean true is converted to 1; boolean false is converted to 0
* a node-set is first converted to a string as if by a call to the [`string`](#fn-string) function and then converted in the same way as a string argument
* an object of a type other than the four basic types is converted to a number in a way that is dependent on that type

If the argument is omitted, it returns `0`.

<a name="fn-sum"></a>**Function:** *Number* **sum**(*node-set*)

The `sum` function returns the sum, for each node in the argument node-set, of the result of converting the string-values of the node to a number.

<a name="fn-abs"></a>**Function:** *Number* **abs**(*Number*)

The `abs` function returns the absolute value of the argument.

<a name="fn-floor"></a>**Function:** *Number* **floor**(*Number*)

The `floor` function returns the largest (closest to positive infinity) number that is not greater than the argument and that is an integer.

<a name="fn-ceil"></a>**Function:** *Number* **ceiling**(*Number*)

The `ceiling` function returns the smallest (closest to negative infinity) number that is not less than the argument and that is an integer.

<a name="fn-round"></a>**Function:** *Number* **round**(*Number*)

The `round` function returns the number that is closest to the argument and that is an integer. If there are two such numbers, then the one that is closest to positive infinity is returned. If the argument is NaN, then NaN is returned. If the argument is positive infinity, then positive infinity is returned. If the argument is negative infinity, then negative infinity is returned. If the argument is positive zero, then positive zero is returned. If the argument is negative zero, then negative zero is returned. If the argument is less than zero, but greater than or equal to -0.5, then negative zero is returned.

**NOTE:** For these last two cases, the result of calling the [`round`](#fn-round) function is not the same as the result of adding 0.5 and then calling the [`floor`](#fn-floor) function.


### <a name="boolean-functions"></a>Boolean Functions

Boolean Functions

<a name="fn-boolean"></a>**Function:** *Boolean* **Boolean**(*object*)

The `boolean` function converts its argument to a boolean as follows:

* a `number` is true if and only if it is neither positive or negative zero nor NaN
* a `node-set` is true if and only if it is non-empty
* a `string` is true if and only if its length is non-zero
* an object of a type other than the four basic types is converted to a boolean in a way that is dependent on that type

<a name="fn-not"></a>**Function:** *Boolean* **not**(*Boolean*)

The `not` function returns true if its argument is false, and false otherwise.

<a name="fn-true"></a>**Function:** *Boolean* **true**()

The `true` function returns true.

<a name="fn-false"></a>**Function:** *Boolean* **false**()

The `false` function returns false.

### <a name="node-set-functions"></a>Node Set Functions

<a name="fn-last"></a>**Function:** *Number* **last**()

The `last` function returns a number equal to the context size from the expression evaluation context.

<a name="fn-position"></a>**Function:** *Number* **position**()

The `position` function returns a number equal to the context position from the expression evaluation context.

<a name="fn-count"></a>**Function:** *Number* **count**(*node-set*)

The `count` function returns the number of nodes in the argument node-set.

<a name="fn-base"></a>**Function:** *String* **base**(*node-set?*)

The `base` function returns the base part of the file name of the node in the argument node-set that is first in filesystem order. This excludes the file name extension such as `.jpg`. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-extension"></a>**Function:** *String* **extension**(*node-set?*)

The `extension` function returns the extension part of the file name of the node in the argument node-set that is first in filesystem order. This excludes any part of the file name up to a `.`, and includes only the extension itself, such as `jpg` or `txt`. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-name"></a>**Function:** *String* **name**(*node-set?*)

The `name` function returns a string containing the file name of the node in the argument node-set that is first in filesystem order. This includes both the base and extension parts of the filename. If the argument node-set is empty or the first node has no file name, an empty string is returned. If the argument it omitted, it defaults to a node-set with the context node as its only member.

**NOTE:** The string returned by the [`name`](#fn-name) function will be the same as the string returned by the [`base`](#fn-base) function for folder nodes. For file nodes, they will differ.

<a name="fn-bytes"></a>**Function:** *Number* **bytes**(*node-set?*)

<a name="fn-kilobytes"></a>**Function:** *Number* **kilobytes**(*node-set?*)

<a name="fn-megabytes"></a>**Function:** *Number* **megabytes**(*node-set?*)

<a name="fn-gigabytes"></a>**Function:** *Number* **gigabytes**(*node-set?*)

The `bytes` function returns the size in bytes of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

**NOTE:** the `kilobytes`, `megabytes` and `gigabytes` functions return decimal (as opposed to binary) values. That is, 1000 bytes are 1 KB. This matches the OS X Finder behavior as of OS X 10.10 Yosemite.

<a name="fn-permissions"></a>**Function:** *Number* **permissions**(*node-set?*)

The `permissions` function returns the posix permissions of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-owner"></a>**Function:** *String* **owner**(*node-set?*)

The `owner` function returns the account name of the user owner of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-group"></a>**Function:** *String* **group**(*node-set?*)

The `group` function returns the account name of the group owner of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

### <a name="formatting-functions"></a>Formatting Functions

<a name="fn-format-number"></a>**Function:** *String* **format-number**(*Number*, *String*)

The `format-number` function returns a formatted string representation of the number argument using the string argument as a format template. The template patterns match those [defined by XSLT 1.0](http://www.w3schools.com/xsl/func_formatnumber.asp).

<a name="fn-format-date"></a>**Function:** *String* **format-date**(*date*, *String*)

The `format-date` function returns a formatted string representation of the date argument using the string argument as a format template. The template patterns are described in the [Unicode TR35](http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns).

<a name="fn-format-bytes"></a>**Function:** *String* **format-bytes**(*Number*)

<a name="fn-format-kilobytes"></a>**Function:** *String* **format-kilobytes**(*Number*)

<a name="fn-format-megabytes"></a>**Function:** *String* **format-megabytes**(*Number*)

<a name="fn-format-gigabytes"></a>**Function:** *String* **format-gigabytes**(*Number*)

The `format-bytes` function returns a formatted string representation of the byte count passed as the first number argument.

The `format-kilobytes`, `format-megabytes`, and `format-gigabytes` functions expect number arguments which respectively represent kilobytes, megabytes, and gigabytes. All of these functions will return the same formated string for a given number of *bytes*, but each function evaluates the provided number argument as a value given in the magnitude of the function's name.

Some example results:

Input                      | Output
-------------------------- | -------------
format-bytes(5000)         | '5 KB'
format-kilobytes(5000)     | '5.0 MB'
format-megabytes(5000)     | '5.00 GB'
format-gigabytes(5000)     | '5.00 TB'

