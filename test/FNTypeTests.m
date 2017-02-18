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
    [self eval:@"var b=type(null)=='Object';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeTrue {
    [self eval:@"var b=type(true)=='Boolean';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeFalse {
    [self eval:@"var b=type(false)=='Boolean';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testType1 {
    [self eval:@"var b=type(1)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeNeg1 {
    [self eval:@"var b=type(-1)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testType0 {
    [self eval:@"var b=type(0)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeNaN {
    [self eval:@"var b=type(NaN)=='Number';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testTypeString {
    [self eval:@"var b=type('foo')=='String';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)test1Eq1 {
    [self eval:@"var b=1=='1';"];
    TDTrue([self boolForName:@"b"]);
}

- (void)test1Eq2 {
    [self eval:@"var b=1=='2';"];
    TDEquals(NO, [self boolForName:@"b"]);
}

- (void)testNumber1EqNumberTrue {
    [self eval:@"var b=Number('1')==Number(true);"];
    TDTrue([self boolForName:@"b"]);
}

- (void)testIsNan {
    [self eval:@"var b=isNaN(1);"];
    TDFalse([self boolForName:@"b"]);
    
    [self eval:@"var b=isNaN(0.0);"];
    TDFalse([self boolForName:@"b"]);
    
    [self eval:@"var b=isNaN('NaN');"];
    TDFalse([self boolForName:@"b"]);
    
    [self eval:@"var b=isNaN(NaN);"];
    TDTrue([self boolForName:@"b"]);
    
    [self eval:@"var foo=NaN;var b=isNaN(foo);"];
    TDTrue([self boolForName:@"b"]);
}

@end
