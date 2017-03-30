//
//  XPNewlineTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPNewlineTests : XPBaseStatementTests

@end

@implementation XPNewlineTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -
#pragma mark EXPR

- (void)testOrExpr {
    [self eval:@"var foo=0 or 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0\nor 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0 or\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0 or 1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(\n0 or 1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0\nor 1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0 or\n1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0 or 1\n)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAndExpr {
    [self eval:@"var foo=0 and 1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0\nand 1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0 and\n1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0 and 1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(\n0 and 1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0\nand 1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0 and\n1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=(0 and 1\n)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testEqualityExpr {
    [self eval:@"var foo=0\n==1"];
    TDEquals(NO, [self boolForName:@"foo"]);
    
    [self eval:@"var foo=0==\n1"];
    TDEquals(NO, [self boolForName:@"foo"]);
}

- (void)testRelationalExpr {
    [self eval:@"var foo=0\n>1"];
    TDEquals(NO, [self boolForName:@"foo"]);
    
    [self eval:@"var foo=0>\n1"];
    TDEquals(NO, [self boolForName:@"foo"]);
}

- (void)testMathExpr {
    [self eval:@"var foo=1\n+1"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=1+\n1"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)testNegatedUnaryExpr {
    [self eval:@"var foo=not 1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=not\n1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testSignedPrimaryExpr {
    [self eval:@"var foo=-\n1"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
    
    TDEquals(~1, -2);
    
    [self eval:@"var foo=~1"];
    TDEquals(-2.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=~\n1"];
    TDEquals(-2.0, [self doubleForName:@"foo"]);
}

- (void)testFuncCall {
    [self eval:@"var foo=ceil(12.5)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=ceil\n(12.5)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    TDEqualObjects(@"<sub ceil>", [self stringForName:@"foo"]);
    
    [self eval:@"var foo=ceil(\n12.5)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=ceil(12.5\n)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=pow(3.0,2.0)"];
    TDEquals(9.0, [self doubleForName:@"foo"]);
    
    [self fail:@"var foo=pow\n(3.0,2.0)"];
    TDEqualObjects(XPSyntaxError, self.error.localizedDescription);
    
    [self eval:@"var foo=pow(\n3.0,2.0)"];
    TDEquals(9.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=pow(3.0\n,2.0)"];
    TDEquals(9.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=pow(3.0,\n2.0)"];
    TDEquals(9.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=pow(3.0,2.0\n)"];
    TDEquals(9.0, [self doubleForName:@"foo"]);
}

- (void)testSlicing {
    [self eval:@"var foo=['a','b','c','d'][1]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][\n1]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][\n1\n]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1\n]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:2]"];
    TDEqualObjects(@"['a', 'b']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][\n1:2]"];
    TDEqualObjects(@"['a', 'b']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1\n:2]"];
    TDEqualObjects(@"['a', 'b']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:\n2]"];
    TDEqualObjects(@"['a', 'b']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:2\n]"];
    TDEqualObjects(@"['a', 'b']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:4:2]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][\n1:4:2]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1\n:4:2]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:\n4:2]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:4\n:2]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:4:\n2]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
    
    [self eval:@"var foo=['a','b','c','d'][1:4:2\n]"];
    TDEqualObjects(@"['a', 'c']", [self descriptionForName:@"foo"]);
}

#pragma mark -
#pragma mark STAT

- (void)testVarDecl {
    [self eval:@"var\nfoo = 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo\n= 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo =\n 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssign {
    [self eval:@"var foo=0;foo\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;foo=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssignIndex {
    [self eval:@"var foo=[0];foo\n[1]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[\n1]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[1\n]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[1]\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[0];foo[1]=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssignAppend {
    [self eval:@"var foo=[];foo\n[]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[];foo[\n]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[];foo[]\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=[];foo[]=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testThrowStat {
    [self fail:@"throw 'ohai'"];
    TDEqualObjects(XPRuntimeError, self.error.localizedDescription);
    TDEqualObjects(@"ohai", self.error.localizedFailureReason);
    
    [self fail:@"throw\n'ohai'"];
    TDEqualObjects(XPRuntimeError, self.error.localizedDescription);
    TDEqualObjects(@"ohai", self.error.localizedFailureReason);
}

- (void)testReturnStat {
    [self eval:@"var foo=sub(){return 11}()"];
    TDEquals(11.0, [self doubleForName:@"foo"]);

    [self eval:@"var foo=sub(){return\n11}()"];
    TDEquals(11.0, [self doubleForName:@"foo"]);
}

#pragma mark -
#pragma mark BLOCK

- (void)testIfBlock {
    [self eval:@"var foo=0;if 1 {foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);

    [self eval:@"var foo=0;if\n1 {foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;if 1\n{foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;if 1 {\nfoo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self eval:@"var foo=0;if 1 {foo=22\n}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
}




//- (void)testFuncCallArgument {
//    [self eval:@"var s=replace('abracadabra',\n'bra', '*');"];
//    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
//}

@end
