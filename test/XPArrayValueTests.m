//
//  XPArrayValueTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseExpressionTests.h"

@interface XPArrayValueTests : XPBaseExpressionTests
@end

@implementation XPArrayValueTests

- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testEmpty {
    NSString *input = @"[]";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    id expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([expr boolValue]);
}

- (void)testZero {
    NSString *input = @"[0]";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    id expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr boolValue]);
}

- (void)testMany {
    NSString *input = @"[1,1,1]";
    NSArray *toks = [self tokenize:input];
    
    NSError *err = nil;
    id expr = [self expressionFromTokens:toks error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([expr boolValue]);
}

@end
