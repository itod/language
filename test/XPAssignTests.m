//
//  XPAssignTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPAssignTests : XPBaseStatementTests

@end

@implementation XPAssignTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFooEq2 {
    [self exec:@"var foo = 1; foo = 2;"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)testFooEq2Fail {
    [self fail:@"foo = 2;"];
    TDEqualObjects(XPNameError, self.error.localizedDescription);
}

- (void)testFuncAssignGlobal {
    [self exec:@"sub foo(){x=2;}var x=1;foo();"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testFuncOverrideGlobal {
    [self exec:@"sub foo(){var x=2;}var x=1;foo();"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testFuncNestedOverride {
    [self exec:@"sub f(){var x=2;var y=1000;g();}sub g(){y=x;}var x=1;var y=0;f();"];
    TDEquals(1.0, [self doubleForName:@"y"]);
}

- (void)testLocalNestedOverride {
    [self exec:@"var x=1;var y=0;try{var x=2;y=10;}"];
    TDEquals(1.0, [self doubleForName:@"x"]);
    TDEquals(10.0, [self doubleForName:@"y"]);
}

- (void)testLocalNestedAssign {
    [self exec:@"var x=1;try{x=2;}"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testAssignNull {
    [self exec:@"var x=1;x=null;"];
    TDEqualObjects([XPObject nullObject], [self objectForName:@"x"]);
}

- (void)testAssignNaN {
    [self exec:@"var x=1;x=NaN;"];
    TDEqualObjects([XPObject nanObject], [self objectForName:@"x"]);
}

- (void)testPlusEq {
    [self exec:@"var x=1;x+=1;"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testMinusEq {
    [self exec:@"var x=1;x-=1;"];
    TDEquals(0.0, [self doubleForName:@"x"]);
}

- (void)testTimesEq {
    [self exec:@"var x=1;x*=3;"];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

- (void)testDivEq {
    [self exec:@"var x=9;x/=3;"];
    TDEquals(3.0, [self doubleForName:@"x"]);
}

@end
