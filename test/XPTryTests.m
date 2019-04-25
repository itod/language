//
//  XPTryTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPTryTests : XPBaseStatementTests

@end

@implementation XPTryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTry {
    [self exec:@"var x='foo';try{x='bar';}catch e{}finally{}"];
    TDEqualObjects(@"bar", [self stringForName:@"x"]);
}

- (void)testCatch {
    [self exec:@"var x='foo';try{throw 'boo';}catch e{x='bar';}finally{}"];
    TDEqualObjects(@"bar", [self stringForName:@"x"]);
}

- (void)testCatchFinally {
    [self exec:@"var x='foo';try{x='bar';}catch e{}finally{x='baz';}"];
    TDEqualObjects(@"baz", [self stringForName:@"x"]);
}

- (void)testFinally {
    [self exec:@"var x='foo';try{x='bar';}finally{x='baz';}"];
    TDEqualObjects(@"baz", [self stringForName:@"x"]);
}

- (void)testCatchLocalsCount {
    [self exec:@"var c=0;try{throw'foo';}catch e{c=count(locals());}"];
    TDEquals(1.0, [self doubleForName:@"c"]);
}

- (void)testCaughtObjectScope {
    [self fail:[self sourceForSelector:_cmd]];
}

- (void)testFinallyOnlyRethrowsOnThrow {
    [self fail:@"try {throw 'foo';} finally {}"];
    TDEqualObjects(@"RuntimeError", self.error.localizedDescription);
    TDEqualObjects(@"foo", self.error.localizedFailureReason);
}

- (void)testFinallyOnlyRethrowsOnException {
    [self fail:@"try {map(1, 1);} finally {}"];
    TDEqualObjects(@"TypeError", self.error.localizedDescription);
}

- (void)testExceptionNameReasonLine {
    [self exec:[self sourceForSelector:_cmd]];
    TDEqualObjects(@"AssertionError", [self stringForName:@"name"]);
    TDEqualObjects(@"FOO BAR BAZ", [self stringForName:@"reason"]);
    TDEquals(6.0, [self doubleForName:@"line"]);
}

@end
