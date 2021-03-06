//
//  FNStringTests.m
//  Language
//
//  Created by Todd Ditchendorf on 5/12/14.
//
//

#import "XPBaseStatementTests.h"

@interface FNStringTests : XPBaseStatementTests

@end

@implementation FNStringTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testUppercase {
    [self exec:@"var s=uppercase('a');"];
    TDEqualObjects(@"A", [self stringForName:@"s"]);
    
    [self exec:@"var s=uppercase('ab');"];
    TDEqualObjects(@"AB", [self stringForName:@"s"]);

    [self exec:@"var s=uppercase(0);"];
    TDEqualObjects(@"0", [self stringForName:@"s"]);

    [self exec:@"var s=uppercase(true);"];
    TDEqualObjects(@"TRUE", [self stringForName:@"s"]);
}

- (void)testLowercase {
    [self exec:@"var s=lowercase('A');"];
    TDEqualObjects(@"a", [self stringForName:@"s"]);
    
    [self exec:@"var s=lowercase('AB');"];
    TDEqualObjects(@"ab", [self stringForName:@"s"]);

    [self exec:@"var s=lowercase(9);"];
    TDEqualObjects(@"9", [self stringForName:@"s"]);

    [self exec:@"var s=lowercase(true);"];
    TDEqualObjects(@"true", [self stringForName:@"s"]);
}

- (void)testCompare {
    [self exec:@"var n=compare('a', 'a');"];
    TDEquals(0.0, [self doubleForName:@"n"]);
    
    [self exec:@"var n=compare('a', 'b');"];
    TDEquals(-1.0, [self doubleForName:@"n"]);
    
    [self exec:@"var n=compare('b', 'a');"];
    TDEquals(1.0, [self doubleForName:@"n"]);
}

- (void)testMatches {
    [self exec:@"var b=matches('foo', 'foo');"];
    TDTrue([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('foo', 'FOO');"];
    TDFalse([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('foo', 'FOO', 'i');"];
    TDTrue([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('foo', '\\w+');"];
    TDTrue([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('foo', '\\W+');"];
    TDFalse([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('abracadabra', 'bra');"];
    TDTrue([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('abracadabra', '^a.*a$');"];
    TDTrue([self boolForName:@"b"]);
    
    [self exec:@"var b=matches('abracadabra', '^bra');"];
    TDFalse([self boolForName:@"b"]);
}

- (void)testPosition {
    [self exec:@"var i=position('foo', 'foob');"];
    TDEquals(0.0, [self doubleForName:@"i"]);

    [self exec:@"var i=position('foo', 'foo');"];
    TDEquals(1.0, [self doubleForName:@"i"]);
}

- (void)testReplace {
    [self exec:@"var s=replace('abracadabra', 'bra', '*');"];
    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('abracadabra', 'BRA', '*', 'i');"];
    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('abracadabra', 'a.*a', '*');"];
    TDEqualObjects(@"*", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('abracadabra', 'a.*?a', '*');"];
    TDEqualObjects(@"*c*bra", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('abracadabra', 'a', '');"];
    TDEqualObjects(@"brcdbr", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('abracadabra', 'a(.)', 'a$1$1');"];
    TDEqualObjects(@"abbraccaddabbra", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('abracadabra', '.*?', '$1');"];
    TDEqualObjects(@"abracadabra", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('AAAA', 'A+', 'b');"];
    TDEqualObjects(@"b", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('AAAA', 'A+?', 'b');"];
    TDEqualObjects(@"bbbb", [self stringForName:@"s"]);
    
    [self exec:@"var s=replace('darted', '^(.*?)d(.*)$', '$1c$2');"];
    TDEqualObjects(@"carted", [self stringForName:@"s"]);
}

//replace("abracadabra", "bra", "*") returns "a*cada*"
//replace("abracadabra", "a.*a", "*") returns "*"
//replace("abracadabra", "a.*?a", "*") returns "*c*bra"
//replace("abracadabra", "a", "") returns "brcdbr"
//replace("abracadabra", "a(.)", "a$1$1") returns "abbraccaddabbra"
//replace("abracadabra", ".*?", "$1") raises an error, because the pattern matches the zero-length string
//replace("AAAA", "A+", "b") returns "b"
//replace("AAAA", "A+?", "b") returns "bbbb"
//replace("darted", "^(.*?)d(.*)$", "$1c$2") returns "carted". The first d is replaced.


- (void)testLoadSlice {
    [self eval:@"var a = 'abcdefgh';"];
    TDEqualObjects(@"'a'"           , [self evalString:@"a[1]"]);
    TDEqualObjects(@"'h'"           , [self evalString:@"a[-1]"]);
    TDEqualObjects(@"'abcd'"        , [self evalString:@"a[1:4]"]);
    TDEqualObjects(@"'abcd'"        , [self evalString:@"a[:4]"]);
    TDEqualObjects(@"'efgh'"        , [self evalString:@"a[-4:-1]"]);
    TDEqualObjects(@"'efgh'"        , [self evalString:@"a[-4:]"]);
    TDEqualObjects(@"'de'"          , [self evalString:@"a[4:-4]"]);
    
    TDEqualObjects(@"'abcdefgh'"    , [self evalString:@"a[:]"]);
    TDEqualObjects(@"'abcde'"       , [self evalString:@"a[:5]"]);
    TDEqualObjects(@"'abcdefgh'"    , [self evalString:@"a[:-1]"]);
    TDEqualObjects(@"'defgh'"       , [self evalString:@"a[4:]"]);
    TDEqualObjects(@"'fgh'"         , [self evalString:@"a[-3:]"]);
    TDEqualObjects(@"'bcde'"        , [self evalString:@"a[2:5]"]);
    TDEqualObjects(@"'bcdefgh'"     , [self evalString:@"a[2:-1]"]);
    TDEqualObjects(@"'fgh'"         , [self evalString:@"a[-3:-1]"]);
    
    [self eval:@"var b = a[4:]"];
    TDEqualObjects(@"'defgh'"       , [self evalString:@"b"]);
    
#if MUTABLE_STRINGS
    [self eval:@"b[2]=99"];
    TDEqualObjects(@"'d99fgh'"      , [self evalString:@"b"]);
#endif
    TDEqualObjects(@"'abcdefgh'"    , [self evalString:@"a"]);
    

    [self eval:@"var c = a[:]"]; // copy
    TDEqualObjects(@"'abcdefgh'"    , [self evalString:@"c"]);
    
#if MUTABLE_STRINGS
    [self eval:@"c[-1]=47"];
    TDEqualObjects(@"'abcdefg47'"   , [self evalString:@"c"]);
#endif
    TDEqualObjects(@"'abcdefgh'"    , [self evalString:@"a"]);
    
    [self eval:@"var d = a"]; // ref
    TDEqualObjects(@"'abcdefgh'"    , [self evalString:@"d"]);
#if MUTABLE_STRINGS
    [self eval:@"d[1]=42"];
    TDEqualObjects(@"'42bcdefgh'"   , [self evalString:@"d"]);
    TDEqualObjects(@"'42bcdefgh'"   , [self evalString:@"a"]);
#endif
}

#if MUTABLE_STRINGS
- (void)testAssignSlice {
    [self eval:@"var a = 'abcdefgh';"];
    
    [self eval:@"a[2:7]=[99, 22, 14]"];
    //TDEqualObjects(@"'a992214h'"   , [self evalString:@"a"]);
    TDEqualObjects(@"'a[99, 22, 14]h'"   , [self evalString:@"a"]);
}
#endif

- (void)testOrd1 {
    [self eval:@"var n=ord('A');"];
    TDEqualObjects(@"65", [[self objectForName:@"n"] reprValue]);
}

- (void)testOrd2 {
    [self eval:@"var n=ord('a');"];
    TDEqualObjects(@"97", [[self objectForName:@"n"] reprValue]);
}

- (void)testChr1 {
    [self eval:@"var n=chr(65);"];
    TDEqualObjects(@"'A'", [[self objectForName:@"n"] reprValue]);
}

- (void)testChr2 {
    [self eval:@"var n=chr(97);"];
    TDEqualObjects(@"'a'", [[self objectForName:@"n"] reprValue]);
}

@end
