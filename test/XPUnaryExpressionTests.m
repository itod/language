//
//  XPUnaryExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseStatementTests.h"

@interface XPUnaryExpressionTests : XPBaseStatementTests
@property (nonatomic, retain) NSOutputStream *output;
@end

@implementation XPUnaryExpressionTests

- (void)setUp {
    [super setUp];
    
    self.output = [NSOutputStream outputStreamToMemory];
}

- (void)tearDown {
    self.output = nil;
    
    [super tearDown];
}

- (NSString *)outputString {
    NSString *str = [[[NSString alloc] initWithData:[_output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];
    return str;
}

- (void)testNeg1 {
    [self eval:@"var foo=-1;"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
}

- (void)testNegNeg1 {
    [self eval:@"var foo=--1;"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

- (void)testNegNegNeg1 {
    [self eval:@"var foo=---1;"];
    TDEquals(-1.0, [self doubleForName:@"foo"]);
}

- (void)testNegNegNegNeg1 {
    [self eval:@"var foo=----1;"];
    TDEquals(1.0, [self doubleForName:@"foo"]);
}

@end
