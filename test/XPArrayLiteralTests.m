//
//  XPArrayLiteralTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPArrayLiteralTests : XPBaseStatementTests

@end

@implementation XPArrayLiteralTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchIndex {
    [self eval:@"var foo=['a','b'];var bar=foo[1];var baz=foo[2];"];
    TDEqualObjects(@"a", [self stringForName:@"bar"]);
    TDEqualObjects(@"b", [self stringForName:@"baz"]);
}

- (void)testFetchNegIndex {
    [self eval:@"var foo=['a','b'];var bar=foo[-1];var baz=foo[-2];"];
    TDEqualObjects(@"b", [self stringForName:@"bar"]);
    TDEqualObjects(@"a", [self stringForName:@"baz"]);
}

- (void)testFetchNegIndex3 {
    [self eval:@"var foo=['a','b','c'];var bar=foo[-1];var baz=foo[-2];var bat=foo[-3];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"b", [self stringForName:@"baz"]);
    TDEqualObjects(@"a", [self stringForName:@"bat"]);
}

- (void)testInsertNegIndex3 {
    [self eval:@"var foo=['a','b','c'];foo[-1]='z';foo[-2]='y';foo[-3]='x';var bar=foo[1];var baz=foo[2];var bat=foo[3];"];
    TDEqualObjects(@"x", [self stringForName:@"bar"]);
    TDEqualObjects(@"y", [self stringForName:@"baz"]);
    TDEqualObjects(@"z", [self stringForName:@"bat"]);
}

- (void)testInsertAtIndex {
    [self eval:@"var foo=['a','b'];foo[1]='c';foo[2]='d';var bar=foo[1];var baz=foo[2];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

- (void)testInsertAtIndexOutOfOrder {
    [self eval:@"var foo=['a','b'];foo[2]='d';foo[1]='c';var bar=foo[1];var baz=foo[2];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

- (void)testAppend {
    [self eval:@"var foo=[];foo[]='c';foo[]='d';var bar=foo[1];var baz=foo[2];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

- (void)testCopyFuncRetVal {
    [self eval:@"var foo=make();foo[]=1;var bar=make();bar[]=2;sub make() {return [];}"];
    TDEqualObjects(@"[1]", [self stringForName:@"foo"]);
    TDEqualObjects(@"[2]", [self stringForName:@"bar"]);
}

- (void)testSetIndexNested {
    [self eval:@"var a=['x'];{a[1]='y';}var b=a[1];"];
    TDEqualObjects(@"y", [self stringForName:@"b"]);
}

- (void)testAppendNested {
    [self eval:@"var a=[];{a[]='c';}var b=a[1];"];
    TDEqualObjects(@"c", [self stringForName:@"b"]);
}

- (void)testSlice {
    [self eval:@"var v=[1,2,3,4,5];var res=v[1:2];"];
    TDEqualObjects(@"[1,2]", [self stringForName:@"res"]);
    
    [self eval:@"var v=[1,2,3,4,5];var res=v[1:3];"];
    TDEqualObjects(@"[1,2,3]", [self stringForName:@"res"]);
    
    [self eval:@"var v=[1,2,3,4,5];var res=v[-1:1];"];
    TDEqualObjects(@"[]", [self stringForName:@"res"]);
}

- (void)testSliceStep {
    [self eval:@"var v=[1,2,3,4,5];var res=v[1:5:2];"];
    TDEqualObjects(@"[1,3,5]", [self stringForName:@"res"]);
}

@end
