//
//  XPNumberExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPNumberExpressionTests : XPBaseStatementTests
@end

@implementation XPNumberExpressionTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testHex {
    [self eval:@"var n=#F;"];
    TDEquals(15.0, [self doubleForName:@"n"]);

    [self eval:@"var n=#FF;"];
    TDEquals(255.0, [self doubleForName:@"n"]);
}

- (void)testBin {
    [self eval:@"var n=$10;"];
    TDEquals(2.0, [self doubleForName:@"n"]);
}

@end
