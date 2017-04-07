//
//  XPNegationExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPNegationExpressionTests : XPBaseStatementTests
@end

@implementation XPNegationExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testNot1 {
    [self exec:@"var foo=not 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpace1 {
    [self exec:@"var foo=! 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBang1 {
    [self exec:@"var foo=!1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNot0 {
    [self exec:@"var foo=not 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangSpace0 {
    [self exec:@"var foo=! 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBang0 {
    [self exec:@"var foo=!0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotTrue {
    [self exec:@"var foo=not true;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpaceTrue {
    [self exec:@"var foo=! true;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangTrue {
    [self exec:@"var foo=!true;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotFalse {
    [self exec:@"var foo=not false;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangSpaceFalse {
    [self exec:@"var foo=! false;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangFalse {
    [self exec:@"var foo=!false;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotOpenTrueClose {
    [self exec:@"var foo=not(true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotSpaceOpenTrueClose {
    [self exec:@"var foo=not(true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpaceOpenTrueClose {
    [self exec:@"var foo=! (true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangOpenTrueClose {
    [self exec:@"var foo=!(true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotOpenFalseClose {
    [self exec:@"var foo=not(false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotSpaceOpenFalseClose {
    [self exec:@"var foo=not (false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangOpenFalseClose {
    [self exec:@"var foo=!(false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangSpaceOpenFalseClose {
    [self exec:@"var foo=! (false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotSpaceSQString {
    [self exec:@"var foo=not 'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotSQString {
    [self exec:@"var foo=not'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpaceSQString {
    [self exec:@"var foo=! 'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSQString {
    [self exec:@"var foo=!'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotSpaceEmptySQString {
    [self exec:@"var foo=not '';"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotEmptySQString {
    [self exec:@"var foo=not'';"];
    TDTrue([self boolForName:@"foo"]);
}

@end
