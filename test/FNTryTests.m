//
//  FNTryTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNTryTests : XPBaseStatementTests

@end

@implementation FNTryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTry {
    [self eval:@"var x='foo';try{x='bar'}catch e{}finally{}"];
    TDEqualObjects(@"bar", [self stringForName:@"x"]);
}

//- (void)testLocalsInLocalBlock {
//    [self eval:[self sourceForSelector:_cmd]];
//    TDEquals(42.0, [self doubleForName:@"x"]);
//    TDEquals(47.0, [self doubleForName:@"y"]);
//}
//
@end
