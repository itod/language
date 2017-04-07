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

- (void)testTypeNull {
    [self exec:@"var b=type(null)=='Object';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeTrue {
    [self exec:@"var b=type(true)=='Boolean';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeFalse {
    [self exec:@"var b=type(false)=='Boolean';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testType1 {
    [self exec:@"var b=type(1)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeNeg1 {
    [self exec:@"var b=type(-1)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testType0 {
    [self exec:@"var b=type(0)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeNaN {
    [self exec:@"var b=type(NaN)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeString {
    [self exec:@"var b=type('foo')=='String';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)test1Eq1 {
    [self exec:@"var b=1=='1';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)test1Eq2 {
    [self exec:@"var b=1=='2';"];
    TDEquals(NO, [self boolForName:@"b"]);
}

- (void)testNumber1EqNumberTrue {
    [self exec:@"var b=Number('1')==Number(true);"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testIsNan {
    [self exec:@"var b=isNaN(1);"];
    TDFalse([self boolForName:@"b"]);
}

- (void)testIsNan1 {
    [self exec:@"var b=isNaN(0.0);"];
    TDFalse([self boolForName:@"b"]);
}

- (void)testIsNan2 {
    [self exec:@"var b=isNaN('NaN');"];
    TDFalse([self boolForName:@"b"]);
}

- (void)testIsNan3 {
    [self exec:@"var b=isNaN(NaN);"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testIsNan4 {
    [self exec:@"var foo=NaN;var b=isNaN(foo);"];
    TDTrue([self boolForName:@"b"]);
}

@end
