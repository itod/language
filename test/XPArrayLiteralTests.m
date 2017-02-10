//
//  XPArrayLiteralTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

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
    [self eval:@"var foo=['a','b'];var bar=foo[0];var baz=foo[1];"];
    TDEqualObjects(@"a", [self stringForName:@"bar"]);
    TDEqualObjects(@"b", [self stringForName:@"baz"]);
}

- (void)testInsertAtIndex {
    [self eval:@"var foo=['a','b'];foo[0]='c';foo[1]='d';var bar=foo[0];var baz=foo[1];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

- (void)testInsertAtIndexOutOfOrder {
    [self eval:@"var foo=['a','b'];foo[1]='d';foo[0]='c';var bar=foo[0];var baz=foo[1];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

- (void)testAppend {
    [self eval:@"var foo=[];foo[]='c';foo[]='d';var bar=foo[0];var baz=foo[1];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

//- (void)testWOW {
//    [self eval:@"var foo=make();foo[]=1;var bar=make();bar[]=2;sub make() {return [];}"];
//    TDEqualObjects(@"[1,]", [self stringForName:@"foo"]);
//    TDEqualObjects(@"[2,]", [self stringForName:@"bar"]);
//}

@end
