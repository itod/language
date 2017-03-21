//
//  XPFuncDeclTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPFuncDeclTests : XPBaseStatementTests

@end

@implementation XPFuncDeclTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSubFoo {
    [self eval:@"sub foo() {}"];
}

- (void)testSubFooCall {
    [self eval:@"sub foo() {} foo();"];
}

- (void)testSubFooRet1Plus1 {
    [self eval:@"sub foo() { return 1+1; }"];
}

- (void)testCallSubFooRet1Plus1 {
    [self eval:@"var bar = foo(); sub foo() { return 1+1; }"];
    TDEquals(2.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubFooRetAPlusB {
    [self eval:@"var bar = foo(); sub foo() { var a = 1; var b = 3; return a + b; }"];
    TDEquals(4.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubFooRetAPlusBGlobal {
    [self eval:@"var b=5;var bar=foo();sub foo(){var a=10;return a+b;}"];
    TDEquals(15.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubFooRetAPlusBGlobalFail {
    [self fail:@"var bar=foo();var b=5;sub foo(){var a=10;return a+b;}"];
    TDEqualObjects(XPExceptionUndeclaredSymbol, self.error.localizedDescription);
}

- (void)testCallSubArg {
    [self eval:@"var x=2;var bar=foo(x);sub foo(a){var b=10;return a+b;}"];
    TDEquals(12.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubArg2 {
    [self eval:@"var bar=foo(4,5);sub foo(x,y){return x+y;}"];
    TDEquals(9.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubArg2Minus {
    [self eval:@"var bar=foo(10,1);sub foo(x,y){return x -y;}"];
    TDEquals(9.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubArg2MinusNeg {
    [self eval:@"var bar=foo(1,10);sub foo(x,y){return x-y;}"];
    TDEquals(-9.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubArg2MinusNeg2 {
    [self eval:@"var bar=foo(1,10);sub foo(x,y){return x- y;}"];
    TDEquals(-9.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubDefaultVal {
    [self eval:@"var bar = foo(); sub foo(a=77) { return a+1; }"];
    TDEquals(78.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubDefaultValOverride {
    [self eval:@"var bar = foo(22); sub foo(a=77) { return a+1; }"];
    TDEquals(23.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubJustEnoughArgs {
    [self eval:@"var bar = foo(22); sub foo(a,b=1) { return a+b; }"];
    TDEquals(23.0, [self doubleForName:@"bar"]);
}

- (void)testCallSubMissingArg {
    [self fail:@"var bar = foo(22); sub foo(a,b) { }"];
    TDEqualObjects(XPExceptionTooFewArguments, self.error.localizedDescription);
}

- (void)testCallSubMisorderedArg {
    [self fail:@"var bar = foo(1,2); sub foo(a=10,b) { }"];
    TDEqualObjects(XPExceptionSyntaxError, self.error.localizedDescription);
}

- (void)testDupeParams {
    [self fail:@"sub foo(a,a) { }"];
    TDEqualObjects(XPExceptionSyntaxError, self.error.localizedDescription);

    [self fail:@"sub foo(b,b=10) { }"];
    TDEqualObjects(XPExceptionSyntaxError, self.error.localizedDescription);
}

- (void)testFoo {
    [self eval:@"var foo=test(0);sub test(n){if 0==n%2 {return true;} else {return false;}}"];
    TDTrue([self boolForName:@"foo"]);
}

- (void)testNestedFunction {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testNestedFwdFunction {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

@end
