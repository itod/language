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

- (void)testMap {
    [self eval:@"var v=[0,1,2];var res=map(v, sub(n){return n+1;});"];
    TDEqualObjects(@"[1,2,3]", [self stringForName:@"res"]);
    
    [self eval:@"var v=[0,1,2];var res=map(v, sub(n){return n-1;});"];
    TDEqualObjects(@"[-1,0,1]", [self stringForName:@"res"]);
}

- (void)testFilter {
    [self eval:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){return 0==n%2;});"];
    TDEqualObjects(@"[0,2,4]", [self stringForName:@"res"]);

    [self eval:@"var v=[0,1,2,3,4,5];var res=filter(v, sub(n){if 0==n%2 {return true;} else {return false;}});"];
    TDEqualObjects(@"[0,2,4]", [self stringForName:@"res"]);
}

- (void)testLocalsInLocalBlock {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(47.0, [self doubleForName:@"y"]);
}

- (void)testLocalsInFunction {
    [self eval:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"argX", [self stringForName:@"a"]);
    TDEqualObjects(@"localY", [self stringForName:@"b"]);
}

- (void)testGlobals {
    [self eval:[self sourceForSelector:_cmd]];
    TDEquals(42.0, [self doubleForName:@"x"]);
    TDEquals(42.0, [self doubleForName:@"y"]);
}

@end
