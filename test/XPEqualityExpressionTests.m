//
//  XPEqualityExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPEqualityExpressionTests : XPBaseStatementTests
@end

@implementation XPEqualityExpressionTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Eq1 {
    [self eval:@"var foo=1 == 1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test0EqEqSignNeg0 {
    [self eval:@"var foo=0 == -0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNeg0EqEqSign0 {
    [self eval:@"var foo=-0 == 0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNeg0EqEqSignNeg0 {
    [self eval:@"var foo=-0==-0;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1EqEqSign1 {
    [self eval:@"var foo=1 == 1;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1Eq2 {
    [self eval:@"var foo=1 == 2;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1EqEqSign2 {
    [self eval:@"var foo=1 == 2;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1Ne1 {
    [self eval:@"var foo=1 != 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1NeSign1 {
    [self eval:@"var foo=1 != 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1Ne2 {
    [self eval:@"var foo=1 != 2;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test1NeSign2 {
    [self eval:@"var foo=1 != 2;"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)test0EqNeg0 {
    [self eval:@"var foo=0 == -0;"];
    
    TDEquals(0, -0);
    TDTrue([self boolForName:@"foo"]);
}

- (void)test0NeNeg0 {
    [self eval:@"var foo=0 != -0;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test00EqNeg00 {
    [self eval:@"var foo=0.0 == -0.0;"];
    
    TDEquals(0.0, -0.0);
    TDTrue([self boolForName:@"foo"]);
}

- (void)test00NeNeg00 {
    [self eval:@"var foo=0.0 != -0.0;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testNotOpen1Eq1Close {
    [self eval:@"var foo=not(1 == 1);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBangOpen1EqEqSign1Close {
    [self eval:@"var foo=!(1 == 1);"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testBang1EqEqSign1 {
    [self eval:@"var foo=!1 == 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1EqNot1 {
    [self eval:@"var foo=1 == not 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1EqBangSpace1 {
    [self eval:@"var foo=1 == ! 1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)test1EqSpace1 {
    [self eval:@"var foo=1 == !1;"];
    TDFalse([self boolForName:@"foo"]);
}

- (void)testFooIsBar {
    [self eval:@"var foo=1;var bar=foo;var yn=foo is bar;"];
    TDTrue([self boolForName:@"yn"]);
}

- (void)testFooIsBar2 {
    [self eval:@"var foo=1;var bar=1;var yn=foo is bar;"];
    TDTrue([self boolForName:@"yn"]);
}

- (void)test1Is1 {
    [self eval:@"var foo=1 is 1;"];
    TDTrue([self boolForName:@"foo"]);
}



@end
