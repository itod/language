//
//  XPArithmeticExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPArithmeticExpressionTests : XPBaseStatementTests
@end

@implementation XPArithmeticExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1SpacePlusSpace2 {
    [self exec:@"var foo=1 + 2;"];
    TDEquals(3.0, [self doubleForName:@"foo"]);
}

- (void)test1Plus2 {
    [self exec:@"var foo=1+2;"];
    TDEquals(3.0, [self doubleForName:@"foo"]);
}

- (void)test1SpaceMinusSpace1 {
    [self exec:@"var foo=1 - 1;"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testTruePlus1 {
    [self fail:@"var foo=true + 1;"];
    TDEqualObjects(XPTypeError, self.error.localizedDescription);
}

- (void)testFalsePlus1 {
    [self fail:@"var foo=false + 1;"];
    TDEqualObjects(XPTypeError, self.error.localizedDescription);
}

- (void)test2Times2 {
    [self exec:@"var foo=2*2;"];
    TDEquals(4.0, [self doubleForName:@"foo"]);
}

- (void)test2Div2 {
    [self exec:@"var foo=2/2;"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)test3Plus2Times2 {
    [self exec:@"var foo=3+2*2;"];
    TDEquals(7.0, [self doubleForName:@"foo"]);
}

- (void)testOpen3Plus2CloseTimes2 {
    [self exec:@"var foo=(3+2)*2;"];
    TDEquals(10.0, [self doubleForName:@"foo"]);
}

- (void)testNeg2Mod2 {
    [self exec:@"var foo=-2%2;"];
    TDEquals(-0.0, [self doubleForName:@"foo"]);
}

- (void)testNeg1Mod2 {
    [self exec:@"var foo=-1%2;"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
}

- (void)test0Mod2 {
    [self exec:@"var foo=0%2;"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)test1Mod2 {
    [self exec:@"var foo=1%2;"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)test2Mod2 {
    [self exec:@"var foo=2%2;"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)test3Mod2 {
    [self exec:@"var foo=3%2;"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)test4Mod2 {
    [self exec:@"var foo=4%2;"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testMinus1 {
    [self exec:@"var foo=-1;"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
}

- (void)testMinusMinus1 {
    [self exec:@"var foo=--1;"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)test1PlusMinusMinus1 {
    [self exec:@"var foo=1 + --1;"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)test1MinusMinusMinus1 {
    [self exec:@"var foo=1 - --1;"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testMinusMinus1Plus1 {
    [self exec:@"var foo=--1 + 1;"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)testMinusMinus1Minus1 {
    [self exec:@"var foo=--1 - 1;"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testMinusMinusMinus1 {
    [self exec:@"var foo=---1;"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
}

- (void)testMinusMinusMinusMinus4 {
    [self exec:@"var foo=----4;"];
    TDEquals(4.0, [self doubleForName:@"foo"]);
}

- (void)testZeroDiv {
    [self fail:@"var foo=1/0;"];
    TDEqualObjects(XPZeroDivisionError, self.error.localizedDescription);
}

- (void)testZeroDiv1 {
    [self fail:@"var foo=1/-0;"];
    TDEqualObjects(XPZeroDivisionError, self.error.localizedDescription);
}

- (void)testPlusEq {
    [self exec:@"var n=1;n+=1;"];
    TDEquals(2.0, [self doubleForName:@"n"]);
}

@end
