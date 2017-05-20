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

- (void)testMap {
    [self exec:@"var v=[0,1,2];var res=map(v, sub(n){return n+1});"];
    TDEqualObjects(@"[1, 2, 3]", [self stringForName:@"res"]);
}


- (void)testMap1 {
    [self exec:@"var v=[0,1,2];var res=map(v, sub(n){return n-1});"];
    TDEqualObjects(@"[-1, 0, 1]", [self stringForName:@"res"]);
}

- (void)testFilter {
    [self exec:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){return 0==n%2});"];
    TDEqualObjects(@"[0, 2, 4]", [self stringForName:@"res"]);
}

- (void)testFilter2 {
    [self exec:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){if 0==n%2 {return true} else {return false}});"];
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
    TDEqualObjects([XPObject nullObject], [self valueForName:@"c"]);
}

- (void)testLocalsInFunctionLiteral {
    [self exec:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"argX", [self stringForName:@"a"]);
    TDEqualObjects(@"localY", [self stringForName:@"b"]);
    TDEqualObjects([XPObject nullObject], [self valueForName:@"c"]);
}

- (void)testGlobals {
    [self exec:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(42.0, [self doubleForName:@"y"]);
}

- (void)testPositionStr1 {
    [self exec:@"var x='321';var i=position(x, '1');"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', false);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', 0);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', true);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '1', 1);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, false);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, 0);"];
    TDEquals(3.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 1, true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);

    [self exec:@"var x='321';var i=position(x, 1, 1);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionStr2 {
    [self exec:@"var x='321';var i=position(x, 0);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 0, true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, 0, false);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x='321';var i=position(x, '0');"];
    TDEquals(0.0, [self doubleForName:@"i"]);

    [self exec:@"var x='321';var i=position(x, '0', true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);

    [self exec:@"var x='321';var i=position(x, '0', false);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionStr3 {
    [self exec:@"var x='';var i=position(x, 'a');"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionArr1 {
    [self exec:@"var x=[3,4,5];var i=position(x, 3);"];
    TDEquals(1.0, [self doubleForName:@"i"]);

    [self exec:@"var x=[3,4,5];var i=position(x, 3, false);"];
    TDEquals(1.0, [self doubleForName:@"i"]);

    [self exec:@"var x=[3,4,5];var i=position(x, 3, true);"];
    TDEquals(1.0, [self doubleForName:@"i"]);

    [self exec:@"var x=[3,4,5];var i=position(x, '3');"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, '3', false);"];
    TDEquals(1.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x=[3,4,5];var i=position(x, '3', true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionArr2 {
    [self exec:@"var x=[3,4,5];var i=position(x, 1);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionArr3 {
    [self exec:@"var x=[];var i=position(x, 3);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

- (void)testPositionDict1 {
    [self exec:@"var x={};x[3]=null;var i=position(x, 3);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x={3:null};var i=position(x, 3);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=position(x, 3);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
    
    [self exec:@"var x={'3':null};var i=position(x, 3, true);"];
    TDEquals(0.0, [self doubleForName:@"i"]);
}

@end
