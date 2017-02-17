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

- (void)testLoopString {
    [self eval:@"var x='321';var y='';for el in x {y[]=el;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(3.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testLoopArray {
    [self eval:@"var x=[3,2,1];var y=[];for el in x {y[]=el;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(3.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testLoopDict {
    [self eval:@"var x={'a':'1','b':'2','c':'3'};var y={};for key,val in x {y[key]=val;}var a=y['a'];var b=y['b'];var c=y['c'];"];
    TDEquals(1.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(3.0, [self doubleForName:@"c"]);
}

- (void)testLoopRange {
    [self eval:@"var y=[];for i in range(3) {y[]=i;}var a=y[1];var b=y[2];var c=y[3];"];
    TDEquals(1.0, [self doubleForName:@"a"]);
    TDEquals(2.0, [self doubleForName:@"b"]);
    TDEquals(3.0, [self doubleForName:@"c"]);
}

- (void)testNestedLoops {
    [self eval:@"var x=0;for i in range(3) {for j in range(3){log(x);x=x+i;}}"];
    TDEquals(18.0, [self doubleForName:@"x"]);
}

- (void)testNestedLoops2 {
    [self eval:@"var x=0;for i in range(3) {for j in range(3){log(i);x=x+i;}}"];
    TDEquals(18.0, [self doubleForName:@"x"]);
}

- (void)testClosuresLoop {
    [self eval:@"var funcs=[];for i in range(3){funcs[]=sub(){log(i);};}for func in funcs {func();}"];
}

- (void)testGlobalVarFromClosure {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testGlobalVarFromClosure2 {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testGlobalVarFromClosure3 {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testLocalVarFromClosure {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(47.0, [self doubleForName:@"x"]);
}

- (void)testClosuresLoopWithGlobalVar {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testClosuresLoopWithLocalVar {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testDoubleNestedClosure {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

@end
