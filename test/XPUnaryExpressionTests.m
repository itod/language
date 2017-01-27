//
//  XPUnaryExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseExpressionTests.h"

@interface XPUnaryExpressionTests : XPBaseExpressionTests
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
    NSString *input = @"-1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNeg1 {
    NSString *input = @"--1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNeg1 {
    NSString *input = @"---1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(-1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

- (void)testNegNegNegNeg1 {
    NSString *input = @"----1";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDEquals(1, [[expr simplify] evaluateAsNumberInContext:nil]);
}

@end
