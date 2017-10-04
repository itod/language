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

<a name="boolean"></a>**Term:** **Boolean**

An object of type boolean can have one of two values, true and false.

    true

    false

<a name="number"></a>**Term:** **Number**

A number represents a floating-point number. A number can have any double-precision 64-bit format [IEEE 754](http://www.w3.org/TR/xpath/#IEEE754) value.

The numeric operators convert their operands to numbers as if by calling the [`Number`](#fn-number) function.

    42

    3.14

    1.6E-35

<a name="string"></a>**Term:** **String**

Strings consist of a sequence of zero or more [Unicode](http://www.unicode.org/ "Unicode Consortium") characters.

    'Evil will always triumph, because good is dumb.'    

    "It's not a tumor!"

<a name="array"></a>**Term:** **Array**

TODO

<a name="dictionary"></a>**Term:** **Dictionary**

TODO

<a name="function"></a>**Term:** **Function**

TODO

### <a name="string-functions"></a>String Functions

<a name="fn-string"></a>**Function:** *string* **String**(*object?*)

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
* TODO Array
* TODO Dictionary
* TODO Subroutine
* If the argument is omitted, it returns the empty string.

**NOTE:** The [`String`](#fn-string) function is not intended for converting numbers into strings for presentation to users. The [`format-number`](#fn-format-number) function provides this functionality.

<a name="fn-matches"></a>**Function:** *string* **matches**(*string input*, *string pattern*, *string? flags*)

The `matches` function returns true if `input` matches the regular expression supplied as `pattern` as influenced by the value of `flags`, if present; otherwise, it returns false.

The available flags are:
* `s`: If present, the match operates in "dot-all" mode. (Perl calls this the single-line mode.)
* `m`: If present, the match operates in multi-line mode.
* `i`: If present, the match operates in case-insensitive mode.
* `x`: If present, whitespace characters (`#x9`, `#xA`, `#xD` and `#x20`) in the regular expression are removed prior to matching with one exception: whitespace characters within character class expressions are not removed. This flag can be used, for example, to break up long regular expressions into readable lines.

<a name="fn-replace"></a>**Function:** *string* **replace**(*string input*, *string pattern*, *string replacement*, *string? flags*)

The `replace` function returns the string that is obtained by replacing each non-overlapping substring of `input` that matches the given regular expression supplied as `pattern` with an occurrence of the `replacement` string.

The `flags` argument is interpreted in the same manner as for the [`matches`](#fn-matches) function.

<a name="fn-compare"></a>**Function:** *string* **compare**(*string*, *string*)

The `compare` function returns -1, 0, or 1, depending on whether the value of the first argument is respectively less than, equal to, or greater than the value of the second argument, according to the rules of lexical string comparison.

<a name="fn-concat"></a>**Function:** *string* **concat**(*string*, *string*, *string*)

The `concat` function returns the concatenation of its arguments.

<a name="fn-starts-with"></a>**Function:** *boolean* **starts-with**(*string*, *string*)

The `starts-with` function returns true if the first argument string starts with the second argument string, and otherwise returns false.

<a name="fn-ends-with"></a>**Function:** *boolean* **ends-with**(*string*, *string*)

The `ends-with` function returns true if the first argument string ends with the second argument string, and otherwise returns false.

<a name="fn-contains"></a>**Function:** *boolean* **contains**(*string*, *string*)

The `contains` function returns true if the first argument string contains the second argument string, and otherwise returns false.

<a name="fn-substring-before"></a>**Function:** *string* **substring-before**(*string*, *string*)

The `substring-before` function returns the substring of the first argument string that precedes the first occurrence of the second argument string in the first argument string, or the empty string if the first argument string does not contain the second argument string. For example, `substring-before("1999/04/01","/")` returns `1999`.

<a name="fn-substring-after"></a>**Function:** *string* **substring-after**(*string*, *string*)

The `substring-after` function returns the substring of the first argument string that follows the first occurrence of the second argument string in the first argument string, or the empty string if the first argument string does not contain the second argument string. For example, `substring-after("1999/04/01","/")` returns `04/01`, and `substring-after("1999/04/01","19")` returns `99/04/01`.

<a name="fn-substring"></a>**Function:** *string* **substring**(*string*, *number*, *number?*)

The `substring` function returns the substring of the first argument starting at the position specified in the second argument with length specified in the third argument. For example, `substring("12345",2,3)` returns `"234"`. If the third argument is not specified, it returns the substring starting at the position specified in the second argument and continuing to the end of the string. For example, `substring("12345",2)` returns `"2345"`.

More precisely, each character in the string is considered to have a numeric position: the position of the first character is 1, the position of the second character is 2 and so on.

**NOTE:** This differs from Java and ECMAScript, in which the String.substring method treats the position of the first character as 0.
The returned substring contains those characters for which the position of the character is greater than or equal to the rounded value of the second argument and, if the third argument is specified, less than the sum of the rounded value of the second argument and the rounded value of the third argument; the comparisons and addition used for the above follow the standard IEEE 754 rules; rounding is done as if by a call to the [`round`](#fn-round) function. The following examples illustrate various unusual cases:

* `substring("12345", 1.5, 2.6)` returns `"234"`
* `substring("12345", 0, 3)` returns `"12"`
* `substring("12345", 0 div 0, 3)` returns `""`
* `substring("12345", 1, 0 div 0)` returns `""`
* `substring("12345", -42, 1 div 0)` returns `"12345"`
* `substring("12345", -1 div 0, 1 div 0)` returns `""`

<a name="fn-string-length"></a>**Function:** *number* **string-length**(*string?*)

The `string-length` returns the number of characters in the string. If the argument is omitted, it defaults to the context node converted to a string, in other words the string-value of the context node.

<a name="fn-normalize-space"></a>**Function:** *string* **normalize-space**(*string?*)

The `normalize-space` function returns the argument string with whitespace normalized by stripping leading and trailing whitespace and replacing sequences of whitespace characters by a single space. Whitespace characters are the same as those allowed by the S production in XML (newline `#xA`, carriage return `#xD`, space `#x20`, and tab `#x9`). If the argument is omitted, it defaults to the context node converted to a string, in other words the string-value of the context node.

<a name="fn-trim-space"></a>**Function:** *string* **trim-space**(*string?*)

The `trim-space` function returns the argument string with leading and trailing whitespace removed. Whitespace characters are the same as those allowed by the S production in XML (newline `#xA`, carriage return `#xD`, space `#x20`, and tab `#x9`). If the argument is omitted, it defaults to the context node converted to a string, in other words the string-value of the context node.

<a name="fn-lower-case"></a>**Function:** *string* **lower-case**(*string*)

The `lower-case` function returns the argument string as a lowercase string.

<a name="fn-upper-case"></a>**Function:** *string* **upper-case**(*string*)

The `upper-case` function returns the argument string as a uppercase string.

<a name="fn-title-case"></a>**Function:** *string* **title-case**(*string*)

The `title-case` function returns the argument string with the first charater converted to a uppercase character.

<a name="fn-translate"></a>**Function:** *string* **translate**(*string*, *string*, *string*)

The `translate` function returns the first argument string with occurrences of characters in the second argument string replaced by the character at the corresponding position in the third argument string. For example, `translate("bar","abc","ABC")` returns the string `BAr`. If there is a character in the second argument string with no character at a corresponding position in the third argument string (because the second argument string is longer than the third argument string), then occurrences of that character in the first argument string are removed. For example, `translate("--aaa--","abc-","ABC")` returns `"AAA"`. If a character occurs more than once in the second argument string, then the first occurrence determines the replacement character. If the third argument string is longer than the second argument string, then excess characters are ignored.

**NOTE:** The [`translate`](#fn-translate) function is not a sufficient solution for case conversion in all languages. A future version of XPath may provide additional functions for case conversion.

### <a name="date-functions"></a>Date Functions

<a name="fn-date"></a>**Function:** *date* **date**(*object?*)

The `date` function converts an object to a date as follows:

* A boolean is converted to a date as follows:
    * a `false()` argument is converted to a date in the very distant past.
    * a `true()` argument is converted to a date in the very distant future.
* A number is converted to a date as follows:
    * A positive number is converted to a date with the given number in seconds in the future
    * A negative number is converted to a date with the given number of seconds in the past
* A string is converted to a date using natural language parsing provided by Apple's `NSDate` class.
* A node-set is converted to a string by returning the creation date of the node in the node-set that is first in filesystem order. If the node-set is empty, an empty string is returned.
* If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-now"></a>**Function:** *date* **now**()

The `now` function returns a date representing the current date and time.

<a name="fn-created"></a>**Function:** *date* **created**(*node-set?*)

The `created` function returns the creation date of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-modified"></a>**Function:** *date* **modified**(*node-set?*)

The `created` function returns the modification date of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

### <a name="number-functions"></a>Number Functions

<a name="fn-number"></a>**Function:** *number* **number**(*object?*)

The `number` function converts its argument to a number as follows:

* a string that consists of optional whitespace followed by an optional minus sign followed by a Number followed by whitespace is converted to the IEEE 754 number that is nearest (according to the IEEE 754 round-to-nearest rule) to the mathematical value represented by the string; any other string is converted to NaN
* boolean true is converted to 1; boolean false is converted to 0
* a node-set is first converted to a string as if by a call to the [`string`](#fn-string) function and then converted in the same way as a string argument
* an object of a type other than the four basic types is converted to a number in a way that is dependent on that type

If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-sum"></a>**Function:** *number* **sum**(*node-set*)

The `sum` function returns the sum, for each node in the argument node-set, of the result of converting the string-values of the node to a number.

<a name="fn-abs"></a>**Function:** *number* **abs**(*number*)

The `abs` function returns the absolute value of the argument.

<a name="fn-floor"></a>**Function:** *number* **floor**(*number*)

The `floor` function returns the largest (closest to positive infinity) number that is not greater than the argument and that is an integer.

<a name="fn-ceiling"></a>**Function:** *number* **ceiling**(*number*)

The `ceiling` function returns the smallest (closest to negative infinity) number that is not less than the argument and that is an integer.

<a name="fn-round"></a>**Function:** *number* **round**(*number*)

The `round` function returns the number that is closest to the argument and that is an integer. If there are two such numbers, then the one that is closest to positive infinity is returned. If the argument is NaN, then NaN is returned. If the argument is positive infinity, then positive infinity is returned. If the argument is negative infinity, then negative infinity is returned. If the argument is positive zero, then positive zero is returned. If the argument is negative zero, then negative zero is returned. If the argument is less than zero, but greater than or equal to -0.5, then negative zero is returned.

**NOTE:** For these last two cases, the result of calling the [`round`](#fn-round) function is not the same as the result of adding 0.5 and then calling the [`floor`](#fn-floor) function.


### <a name="boolean-functions"></a>Boolean Functions

Boolean Functions

<a name="fn-boolean"></a>**Function:** *boolean* **boolean**(*object*)

The `boolean` function converts its argument to a boolean as follows:

* a `number` is true if and only if it is neither positive or negative zero nor NaN
* a `node-set` is true if and only if it is non-empty
* a `string` is true if and only if its length is non-zero
* an object of a type other than the four basic types is converted to a boolean in a way that is dependent on that type

<a name="fn-not"></a>**Function:** *boolean* **not**(*boolean*)

The `not` function returns true if its argument is false, and false otherwise.

<a name="fn-true"></a>**Function:** *boolean* **true**()

The `true` function returns true.

<a name="fn-false"></a>**Function:** *boolean* **false**()

The `false` function returns false.

### <a name="node-set-functions"></a>Node Set Functions

<a name="fn-last"></a>**Function:** *number* **last**()

The `last` function returns a number equal to the context size from the expression evaluation context.

<a name="fn-position"></a>**Function:** *number* **position**()

The `position` function returns a number equal to the context position from the expression evaluation context.

<a name="fn-count"></a>**Function:** *number* **count**(*node-set*)

The `count` function returns the number of nodes in the argument node-set.

<a name="fn-base"></a>**Function:** *string* **base**(*node-set?*)

The `base` function returns the base part of the file name of the node in the argument node-set that is first in filesystem order. This excludes the file name extension such as `.jpg`. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-extension"></a>**Function:** *string* **extension**(*node-set?*)

The `extension` function returns the extension part of the file name of the node in the argument node-set that is first in filesystem order. This excludes any part of the file name up to a `.`, and includes only the extension itself, such as `jpg` or `txt`. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-name"></a>**Function:** *string* **name**(*node-set?*)

The `name` function returns a string containing the file name of the node in the argument node-set that is first in filesystem order. This includes both the base and extension parts of the filename. If the argument node-set is empty or the first node has no file name, an empty string is returned. If the argument it omitted, it defaults to a node-set with the context node as its only member.

**NOTE:** The string returned by the [`name`](#fn-name) function will be the same as the string returned by the [`base`](#fn-base) function for folder nodes. For file nodes, they will differ.

<a name="fn-bytes"></a>**Function:** *number* **bytes**(*node-set?*)

<a name="fn-kilobytes"></a>**Function:** *number* **kilobytes**(*node-set?*)

<a name="fn-megabytes"></a>**Function:** *number* **megabytes**(*node-set?*)

<a name="fn-gigabytes"></a>**Function:** *number* **gigabytes**(*node-set?*)

The `bytes` function returns the size in bytes of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

**NOTE:** the `kilobytes`, `megabytes` and `gigabytes` functions return decimal (as opposed to binary) values. That is, 1000 bytes are 1 KB. This matches the OS X Finder behavior as of OS X 10.10 Yosemite.

<a name="fn-permissions"></a>**Function:** *number* **permissions**(*node-set?*)

The `permissions` function returns the posix permissions of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-owner"></a>**Function:** *string* **owner**(*node-set?*)

The `owner` function returns the account name of the user owner of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

<a name="fn-group"></a>**Function:** *string* **group**(*node-set?*)

The `group` function returns the account name of the group owner of the node in the argument node-set that is first in filesystem order. If the argument node-set is empty or the first node has no expanded-name, an empty string is returned. If the argument is omitted, it defaults to a node-set with the context node as its only member.

### <a name="formatting-functions"></a>Formatting Functions

<a name="fn-format-number"></a>**Function:** *string* **format-number**(*number*, *string*)

The `format-number` function returns a formatted string representation of the number argument using the string argument as a format template. The template patterns match those [defined by XSLT 1.0](http://www.w3schools.com/xsl/func_formatnumber.asp).

<a name="fn-format-date"></a>**Function:** *string* **format-date**(*date*, *string*)

The `format-date` function returns a formatted string representation of the date argument using the string argument as a format template. The template patterns are described in the [Unicode TR35](http://www.unicode.org/reports/tr35/tr35-31/tr35-dates.html#Date_Format_Patterns).

<a name="fn-format-bytes"></a>**Function:** *string* **format-bytes**(*number*)

<a name="fn-format-kilobytes"></a>**Function:** *string* **format-kilobytes**(*number*)

<a name="fn-format-megabytes"></a>**Function:** *string* **format-megabytes**(*number*)

<a name="fn-format-gigabytes"></a>**Function:** *string* **format-gigabytes**(*number*)

The `format-bytes` function returns a formatted string representation of the byte count passed as the first number argument.

The `format-kilobytes`, `format-megabytes`, and `format-gigabytes` functions expect number arguments which respectively represent kilobytes, megabytes, and gigabytes. All of these functions will return the same formated string for a given number of *bytes*, but each function evaluates the provided number argument as a value given in the magnitude of the function's name.

Some example results:

Input                      | Output
-------------------------- | -------------
format-bytes(5000)         | '5 KB'
format-kilobytes(5000)     | '5.0 MB'
format-megabytes(5000)     | '5.00 GB'
format-gigabytes(5000)     | '5.00 TB'

