//
//  FNAssertTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNAssertTests : XPBaseStatementTests

@end

@implementation FNAssertTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAssertZero {
    [self fail:@"assert(0);"];
    TDEqualObjects(XPAssertionError, self.error.localizedDescription);
}

- (void)testExitAssertZero {
    [self fail:@"exit();assert(0);"];
    TDEqualObjects(XPSystemExitException, self.error.localizedDescription);
}

@end
