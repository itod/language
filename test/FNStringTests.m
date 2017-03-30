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
    [self eval:@"var s=uppercase('a');"];
    TDEqualObjects(@"A", [self stringForName:@"s"]);
    
    [self eval:@"var s=uppercase('ab');"];
    TDEqualObjects(@"AB", [self stringForName:@"s"]);
}

- (void)testLowercase {
    [self eval:@"var s=lowercase('A');"];
    TDEqualObjects(@"a", [self stringForName:@"s"]);
    
    [self eval:@"var s=lowercase('AB');"];
    TDEqualObjects(@"ab", [self stringForName:@"s"]);
}

- (void)testCompare {
    [self eval:@"var n=compare('a', 'a');"];
    TDEquals(0.0, [self doubleForName:@"n"]);
    
    [self eval:@"var n=compare('a', 'b');"];
    TDEquals(-1.0, [self doubleForName:@"n"]);
    
    [self eval:@"var n=compare('b', 'a');"];
    TDEquals(1.0, [self doubleForName:@"n"]);
}

- (void)testMatches {
    [self eval:@"var b=matches('foo', 'foo');"];
    TDTrue([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('foo', 'FOO');"];
    TDFalse([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('foo', 'FOO', 'i');"];
    TDTrue([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('foo', '\\w+');"];
    TDTrue([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('foo', '\\W+');"];
    TDFalse([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('abracadabra', 'bra');"];
    TDTrue([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('abracadabra', '^a.*a$');"];
    TDTrue([self boolForName:@"b"]);
    
    [self eval:@"var b=matches('abracadabra', '^bra');"];
    TDFalse([self boolForName:@"b"]);
}

- (void)testReplace {
    [self eval:@"var s=replace('abracadabra', 'bra', '*');"];
    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('abracadabra', 'BRA', '*', 'i');"];
    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('abracadabra', 'a.*a', '*');"];
    TDEqualObjects(@"*", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('abracadabra', 'a.*?a', '*');"];
    TDEqualObjects(@"*c*bra", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('abracadabra', 'a', '');"];
    TDEqualObjects(@"brcdbr", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('abracadabra', 'a(.)', 'a$1$1');"];
    TDEqualObjects(@"abbraccaddabbra", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('abracadabra', '.*?', '$1');"];
    TDEqualObjects(@"abracadabra", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('AAAA', 'A+', 'b');"];
    TDEqualObjects(@"b", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('AAAA', 'A+?', 'b');"];
    TDEqualObjects(@"bbbb", [self stringForName:@"s"]);
    
    [self eval:@"var s=replace('darted', '^(.*?)d(.*)$', '$1c$2');"];
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

@end
