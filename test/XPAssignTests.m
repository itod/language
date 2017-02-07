//
//  XPAssignTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"
#import "XPNode.h"
#import "XPMemorySpace.h"

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
    [self eval:@"var foo = 1; foo = 2;"];
    TDEquals(2.0, [self doubleForName:@"foo"]);
}

- (void)testFooEq2Fail {
    [self fail:@"foo = 2;"];
    TDEqualObjects(XPExceptionUndeclaredSymbol, self.error.localizedDescription);
}

- (void)testFuncAssignGlobal {
    [self eval:@"var x=1;foo();sub foo(){x=2;}"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

- (void)testFuncOverrideGlobal {
    [self eval:@"var x=1;foo();sub foo(){var x=2;}"];
    TDEquals(1.0, [self doubleForName:@"x"]);
}

- (void)testFuncNestedOverride {
    [self eval:@"var x=1;var y=0;f();sub f(){var x=2;var y=1000;g();}sub g(){y=x;}"];
    TDEquals(1.0, [self doubleForName:@"y"]);
}

- (void)testLocalNestedOverride {
    [self eval:@"var x=1;var y=0;{var x=2;y=10;}"];
    TDEquals(1.0, [self doubleForName:@"x"]);
    TDEquals(10.0, [self doubleForName:@"y"]);
}

- (void)testLocalNestedAssign {
    [self eval:@"var x=1;{x=2;}"];
    TDEquals(2.0, [self doubleForName:@"x"]);
}

@end
