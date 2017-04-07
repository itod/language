//
//  XPBooleanExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPBooleanExpressionTests : XPBaseStatementTests
@end

@implementation XPBooleanExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1 {
    [self exec:@"var foo=1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test0 {
    [self exec:@"var foo=0;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testTrue {
    [self exec:@"var foo=true;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testFalse {
    [self exec:@"var foo=false;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testOpenTrueClose {
    [self exec:@"var foo=(true);"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testOpenFalseClose {
    [self exec:@"var foo=(false);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testSQString {
    [self exec:@"var foo='hello';"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testEmptySQString {
    [self exec:@"var foo='';"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1And0 {
    [self exec:@"var foo=1 and 0;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test0And1 {
    [self exec:@"var foo=0 and 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1And1 {
    [self exec:@"var foo=1 and 1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1Or0 {
    [self exec:@"var foo=1 or 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1PipePipe0 {
    [self exec:@"var foo=1 or 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test0Or1 {
    [self exec:@"var foo=0 or 1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1Or1 {
    [self exec:@"var foo=1 or 1;"];
    TDTrue([self boolForName:@"foo"]);
}

@end
