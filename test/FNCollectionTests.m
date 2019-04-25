//
//  FNCollectionTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNCollectionTests : XPBaseStatementTests

@end

@implementation FNCollectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLiteralSubscript {
    [self exec:@"var res=[0,1,2][3];"];
    TDEqualObjects(@"2", [self stringForName:@"res"]);
}

- (void)testSubExprSubscript {
    [self exec:@"var res=([0,1,2])[2];"];
    TDEqualObjects(@"1", [self stringForName:@"res"]);
}

- (void)testSum {
    [self exec:@"var v=[0,1,2,-10];var res=sum(v);"];
    TDEquals(-7.0, [self doubleForName:@"res"]);
}

- (void)testMap {
    [self exec:@"var v=[0,1,2];var res=map(v, sub(n){return n+1;});"];
    TDEqualObjects(@"[1, 2, 3]", [self stringForName:@"res"]);
}

- (void)testMap1 {
    [self exec:@"var v=[0,1,2];var res=map(v, sub(n){return n-1;});"];
    TDEqualObjects(@"[-1, 0, 1]", [self stringForName:@"res"]);
}

- (void)testFilter {
    [self exec:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){return 0==n%2;});"];
    TDEqualObjects(@"[0, 2, 4]", [self stringForName:@"res"]);
}

- (void)testFilter2 {
    [self exec:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){if 0==n%2 {return true;} else {return false;}});"];
    TDEqualObjects(@"[0, 2, 4]", [self stringForName:@"res"]);
}

- (void)testLocalsInLocalBlock {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(47.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInLocalBlockRecursive {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(47.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInLocalBlockNotRecursive {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals( 0.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInFunctionDecl {
    [self exec:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"argX", [self stringForName:@"a"]);
    TDEqualObjects(@"localY", [self stringForName:@"b"]);
    TDEqualObjects([XPObject nullObject], [self objectForName:@"c"]);
}

- (void)testLocalsInFunctionLiteral {
    [self exec:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"argX", [self stringForName:@"a"]);
    TDEqualObjects(@"localY", [self stringForName:@"b"]);
    TDEqualObjects([XPObject nullObject], [self objectForName:@"c"]);
}

- (void)testGlobals {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(42.0, [self doubleForName:@"y"]);
}

- (void)testContains1 {
    [self exec:@"var x={};x[3]=null;var i=contains(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={3:null};var i=contains(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=contains(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=contains(x, 3);"];
    TDEquals(1, [self boolForName:@"i"]);
}

- (void)testContains2 {
    [self exec:@"var key='3';var x={key:null};var i=contains(x, key);"];
    TDEquals(1, [self boolForName:@"i"]);
}

- (void)testRemove1 {
    [self exec:@"var x={'foo':null};var bevor=contains(x,'foo');var entfernt1=remove(x,'foo');var entfernt2=remove(x,'bar');var danach=contains(x,'foo');"];
    TDEquals(1, [self boolForName:@"bevor"]);
    TDEquals(1, [self boolForName:@"entfernt1"]);
    TDEquals(0, [self boolForName:@"entfernt2"]);
    TDEquals(0, [self boolForName:@"danach"]);
}

@end
