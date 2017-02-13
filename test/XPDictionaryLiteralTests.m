//
//  XPDictionaryLiteralTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

@interface XPDictionaryLiteralTests : XPBaseStatementTests

@end

@implementation XPDictionaryLiteralTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchKey {
    [self eval:@"var foo={'a':'1','b':'2'};var bar=foo['a'];var baz=foo['b'];"];
    TDEqualObjects(@"1", [self stringForName:@"bar"]);
    TDEqualObjects(@"2", [self stringForName:@"baz"]);
}

- (void)testInsertForKey {
    [self eval:@"var foo={'a':'1','b':'2'};foo['a']='3';foo['b']='4';var bar=foo['a'];var baz=foo['b'];"];
    TDEqualObjects(@"3", [self stringForName:@"bar"]);
    TDEqualObjects(@"4", [self stringForName:@"baz"]);
}

- (void)testInsertAtIndexOutOfOrder {
    [self eval:@"var foo={'a':'1','b':'2'};foo['b']='d';foo['a']='c';var bar=foo['a'];var baz=foo['b'];"];
    TDEqualObjects(@"c", [self stringForName:@"bar"]);
    TDEqualObjects(@"d", [self stringForName:@"baz"]);
}

- (void)testCopyFuncRetVal {
    [self eval:@"var foo=make();foo['a']='1';var bar=make();bar['a']='2';var baz=foo['a'];var bat=bar['a'];sub make() {return {};}"];
    TDEqualObjects(@"1", [self stringForName:@"baz"]);
    TDEqualObjects(@"2", [self stringForName:@"bat"]);
}

- (void)testSetIndexNested {
    [self eval:@"var a={'a':1};{a['a']=2;}var b=a['a'];"];
    TDEquals(2.0, [self doubleForName:@"b"]);
}

- (void)testAppendNested {
    [self eval:@"var a={};{a['1']='c';}var b=a['1'];"];
    TDEqualObjects(@"c", [self stringForName:@"b"]);
}

@end
