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

- (void)testCatch {
    [self eval:@"var x='foo';try{throw 'boo'}catch e{x='bar'}finally{}"];
    TDEqualObjects(@"bar", [self stringForName:@"x"]);
}

- (void)testCatchFinally {
    [self eval:@"var x='foo';try{x='bar'}catch e{}finally{x='baz'}"];
    TDEqualObjects(@"baz", [self stringForName:@"x"]);
}

- (void)testFinally {
    [self eval:@"var x='foo';try{x='bar'}finally{x='baz'}"];
    TDEqualObjects(@"baz", [self stringForName:@"x"]);
}

- (void)testCaughtObjectScope {
    [self fail:[self sourceForSelector:_cmd]];
}

@end
