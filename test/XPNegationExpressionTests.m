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
    [self eval:@"var foo=not 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpace1 {
    [self eval:@"var foo=! 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBang1 {
    [self eval:@"var foo=!1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNot0 {
    [self eval:@"var foo=not 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangSpace0 {
    [self eval:@"var foo=! 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBang0 {
    [self eval:@"var foo=!0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotTrue {
    [self eval:@"var foo=not true;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpaceTrue {
    [self eval:@"var foo=! true;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangTrue {
    [self eval:@"var foo=!true;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotFalse {
    [self eval:@"var foo=not false;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangSpaceFalse {
    [self eval:@"var foo=! false;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangFalse {
    [self eval:@"var foo=!false;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotOpenTrueClose {
    [self eval:@"var foo=not(true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotSpaceOpenTrueClose {
    [self eval:@"var foo=not(true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpaceOpenTrueClose {
    [self eval:@"var foo=! (true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangOpenTrueClose {
    [self eval:@"var foo=!(true);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotOpenFalseClose {
    [self eval:@"var foo=not(false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotSpaceOpenFalseClose {
    [self eval:@"var foo=not (false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangOpenFalseClose {
    [self eval:@"var foo=!(false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testBangSpaceOpenFalseClose {
    [self eval:@"var foo=! (false);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotSpaceSQString {
    [self eval:@"var foo=not 'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotSQString {
    [self eval:@"var foo=not'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSpaceSQString {
    [self eval:@"var foo=! 'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangSQString {
    [self eval:@"var foo=!'hello';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotSpaceEmptySQString {
    [self eval:@"var foo=not '';"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNotEmptySQString {
    [self eval:@"var foo=not'';"];
    TDTrue([self boolForName:@"foo"]);
}

@end
