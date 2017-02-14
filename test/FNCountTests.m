//
//  FNCountTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface FNCountTests : XPBaseStatementTests

@end

@implementation FNCountTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoopString {
    [self eval:@"var x='321';var y=count(x);"];
    TDEquals(3.0, [self doubleForName:@"y"]);
}

@end