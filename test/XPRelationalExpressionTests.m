//
//  XPRelationalExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPRelationalExpressionTests : XPBaseStatementTests

@end

@implementation XPRelationalExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Lt1 {
    [self eval:@"var foo=1 < 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1LtEq1 {
    [self eval:@"var foo=1 <= 1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1Lt2 {
    [self eval:@"var foo=1 < 2;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1LtEq2 {
    [self eval:@"var foo=1 <= 2;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1Gt1 {
    [self eval:@"var foo=1 > 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1GtEq1 {
    [self eval:@"var foo=1 >= 1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1Gt2 {
    [self eval:@"var foo=1 > 2;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1GtEq2 {
    [self eval:@"var foo=1 >= 2;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNeg0Lt0 {
    [self eval:@"var foo=-0 < 0;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNeg0Gt0 {
    [self eval:@"var foo=-0.0 > 0.0;"];
    TDFalse([self boolForName:@"foo"]);
}

@end
