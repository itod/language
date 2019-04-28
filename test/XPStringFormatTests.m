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

- (void)testFormatSingleIntToString {
    [self exec:@"var foo='%s' % 3;"];
    TDEqualObjects(@"3", [self stringForName:@"foo"]);
}

- (void)testFormatMultiIntToStr {
    [self exec:@"var foo='%s %s' % [3, 4];"];
    TDEqualObjects(@"3 4", [self stringForName:@"foo"]);
}

- (void)testFormatMultiIntToDec {
    [self exec:@"var foo='%d %d' % [3, 4];"];
    TDEqualObjects(@"3 4", [self stringForName:@"foo"]);
}

- (void)testFormatMultiIntToInt {
    [self exec:@"var foo='%i %i' % [3, 4];"];
    TDEqualObjects(@"3 4", [self stringForName:@"foo"]);
}

- (void)testFormatMultiIntToFloat {
    [self exec:@"var foo='%.1f %.1f' % [3, 4];"];
    TDEqualObjects(@"3.0 4.0", [self stringForName:@"foo"]);
}

@end
