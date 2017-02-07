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

- (void)testAssignGlobal {
    [self eval:@"var x=1;sub(){x=2;}"];
    TDEqualObjects(XPExceptionUndeclaredSymbol, self.error.localizedDescription);
}

@end
