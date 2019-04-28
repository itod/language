//
//  XPStringFormatTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPStringFormatTests : XPBaseStatementTests
@end

@implementation XPStringFormatTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testeFormatIntToString {
    [self exec:@"var foo='%s' % 3;"];
    TDEqualObjects(@"3", [self stringForName:@"foo"]);
}

- (void)testeFormatIntToInt {
    [self exec:@"var foo='%s %s' % [3, 4];"];
    TDEqualObjects(@"3 4", [self stringForName:@"foo"]);
}

@end
