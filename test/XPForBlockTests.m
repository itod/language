//
//  XPForBlockTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPForBlockTests : XPBaseStatementTests

@end

@implementation XPForBlockTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#if MUTABLE_STRINGS
- (void)testLoopString {
    [self exec:@"var x='321';var y='';for el in x {y[]=el;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(3.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(1.0, [self doubleForName:@"c"]);
}
#endif

- (void)testLoopArray {
    [self exec:@"var x=[3,2,1];var y=[];for el in x {y[]=el;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(3.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testLoopDict {
    [self exec:@"var x={'a':'1','b':'2','c':'3'};var y={};for key,val in x {y[key]=val;}var a=y['a'];var b=y['b'];var c=y['c'];"];
    TDEquals(1.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(3.0, [self doubleForName:@"c"]);
}

- (void)testLoopRange {
    [self exec:@"var y=[];for i in range(3) {y[]=i;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(1.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(3.0, [self doubleForName:@"c"]);
}

- (void)testNestedLoops {
    [self exec:@"var x=0;for i in range(3) {for j in range(3){print(x);x=x+i;}}"];
    TDEquals(18.0, [self doubleForName:@"x"]);
}

- (void)testNestedLoops2 {
    [self exec:@"var x=0;for i in range(3) {for j in range(3){print(i);x=x+i;}}"];
    TDEquals(18.0, [self doubleForName:@"x"]);
}

- (void)testClosuresLoop {
    [self exec:@"var funcs=[];for i in range(3){funcs[]=sub(){print(i);};}for func in funcs {func();}"];
}

- (void)testGlobalVarFromClosure {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testGlobalVarFromClosure2 {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testGlobalVarFromClosure3 {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testLocalVarFromClosure {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testLocalVarFromClosure2 {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testClosuresLoopWithGlobalVar {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testClosuresLoopWithLocalVar {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testDoubleNestedClosure {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

@end
