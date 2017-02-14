//
//  FNTypeTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNTypeTests : XPBaseStatementTests

@end

@implementation FNTypeTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTypeTrue {
    [self eval:@"var b=type(true)=='boolean';"];
    TDEquals(YES, [self boolForName:@"b"]);
}

- (void)testTypeFalse {
    [self eval:@"var b=type(false)=='boolean';"];
    TDEquals(YES, [self boolForName:@"b"]);
}

- (void)testType1 {
    [self eval:@"var b=type(1)=='number';"];
    TDEquals(YES, [self boolForName:@"b"]);
}

- (void)testTypeString {
    [self eval:@"var b=type('foo')=='string';"];
    TDEquals(YES, [self boolForName:@"b"]);
}

@end
