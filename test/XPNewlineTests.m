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
    [self exec:@"var foo=0 or 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0\nor 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0 or\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0 or 1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(\n0 or 1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0\nor 1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0 or\n1)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0 or 1\n)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAndExpr {
    [self exec:@"var foo=0 and 1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0\nand 1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0 and\n1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0 and 1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(\n0 and 1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0\nand 1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0 and\n1)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=(0 and 1\n)"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testEqualityExpr {
    [self exec:@"var foo=0\n==1"];
    TDEquals(NO, [self boolForName:@"foo"]);
    
    [self exec:@"var foo=0==\n1"];
    TDEquals(NO, [self boolForName:@"foo"]);
}

- (void)testRelationalExpr {
    [self exec:@"var foo=0\n>1"];
    TDEquals(NO, [self boolForName:@"foo"]);
    
    [self exec:@"var foo=0>\n1"];
    TDEquals(NO, [self boolForName:@"foo"]);
}

- (void)testMathExpr {
    [self exec:@"var foo=1\n+1"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=1+\n1"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)testNegatedUnaryExpr {
    [self exec:@"var foo=not 1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=not\n1"];
    TDEquals(0.0, [self doubleForName:@"foo"]);
}

- (void)testSignedPrimaryExpr {
    [self exec:@"var foo=-\n1"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
    
    TDEquals(~1, -2);
    
    [self exec:@"var foo=~1"];
    TDEquals(-2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=~\n1"];
    TDEquals(-2.0, [self doubleForName:@"foo"]);
}

- (void)testFuncCall {
    [self exec:@"var foo=ceil(12.5)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=ceil\n(12.5)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    TDEqualObjects(@"<sub ceil>", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=ceil(\n12.5)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=ceil(12.5\n)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);

    [self exec:@"var foo=ceil(12.5)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=ceil \n (12.5)"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    TDEqualObjects(@"<sub ceil>", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=ceil( \n 12.5)"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=ceil(12.5 \n )"];
    TDEquals(13.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0,2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self fail:@"var foo=min\n(3.0,2.0)"];
    TDEqualObjects(XPSyntaxError, self.error.localizedDescription);
    
    [self exec:@"var foo=min(\n3.0,2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0\n,2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0,\n2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0,2.0\n)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);

    [self exec:@"var foo=min(3.0,2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self fail:@"var foo=min \n (3.0,2.0)"];
    TDEqualObjects(XPSyntaxError, self.error.localizedDescription);
    
    [self exec:@"var foo=min( \n 3.0,2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0 \n ,2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0, \n 2.0)"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=min(3.0,2.0 \n )"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)testSlicing {
    [self exec:@"var foo=['a','b','c','d'][1]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][\n1]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][\n1\n]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1\n]"];
    TDEqualObjects(@"a", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:2]"];
    TDEqualObjects(@"['a', 'b']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][\n1:2]"];
    TDEqualObjects(@"['a', 'b']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1\n:2]"];
    TDEqualObjects(@"['a', 'b']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:\n2]"];
    TDEqualObjects(@"['a', 'b']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:2\n]"];
    TDEqualObjects(@"['a', 'b']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:4:2]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][\n1:4:2]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1\n:4:2]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:\n4:2]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:4\n:2]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:4:\n2]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
    
    [self exec:@"var foo=['a','b','c','d'][1:4:2\n]"];
    TDEqualObjects(@"['a', 'c']", [self evalString:@"foo"]);
}

- (void)testArrayLiteral {
    [self exec:@"var foo=['a','b']"];
    TDEqualObjects(@"[a, b]", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=[\n'a','b']"];
    TDEqualObjects(@"[a, b]", [self stringForName:@"foo"]);

    [self exec:@"var foo=['a'\n,'b']"];
    TDEqualObjects(@"[a, b]", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=['a',\n'b']"];
    TDEqualObjects(@"[a, b]", [self stringForName:@"foo"]);
    
    [self exec:@"var foo=['a','b'\n]"];
    TDEqualObjects(@"[a, b]", [self stringForName:@"foo"]);
}

- (void)testDictLiteral {
    [self exec:@"var foo={'a':1,'b':2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={\n'a':1,'b':2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={'a'\n:1,'b':2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={'a':\n1,'b':2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={'a':1\n,'b':2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={'a':1,\n'b':2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={'a':1,'b'\n:2}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo={'a':1,'b':2\n}['b']"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

#pragma mark -
#pragma mark STAT

- (void)testVarDecl {
    [self exec:@"var\nfoo = 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo\n= 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo =\n 1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssign {
    [self exec:@"var foo=0;foo\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0;foo=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssignIndex {
    [self exec:@"var foo=[0];foo\n[1]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[0];foo[\n1]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[0];foo[1\n]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[0];foo[1]\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[0];foo[1]=\n1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testAssignAppend {
    [self exec:@"var foo=[];foo\n[]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[];foo[\n]=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[];foo[]\n=1"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=[];foo[]=\n1"];
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
    [self exec:@"var foo=sub(){return 11}()"];
    TDEquals(11.0, [self doubleForName:@"foo"]);

    [self exec:@"var foo=sub(){return\n11}()"];
    TDEquals(11.0, [self doubleForName:@"foo"]);
}

#pragma mark -
#pragma mark BLOCK

- (void)testIfBlock {
    [self exec:@"var foo=0;try {foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);

    [self exec:@"var foo=0;if\n1 {foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0;if 1\n{foo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0;try {\nfoo=22}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
    
    [self exec:@"var foo=0;try {foo=22\n}"];
    TDEquals(22.0, [self doubleForName:@"foo"]);
}




//- (void)testFuncCallArgument {
//    [self exec:@"var s=replace('abracadabra',\n'bra', '*');"];
//    TDEqualObjects(@"a*cada*", [self stringForName:@"s"]);
//}

@end
