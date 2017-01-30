//
//  XPEqualityExpressionTests.m
//  XPTemplateEngineTests
//
//  Created by Todd Ditchendorf on 3/28/14.
//  Copyright (c) 2014 Todd Ditchendorf. All rights reserved.
//

#import "XPBaseExpressionTests.h"

@interface XPEqualityExpressionTests : XPBaseExpressionTests
@end

@implementation XPEqualityExpressionTests

- (void)setUp {
    [super setUp];

}

- (void)tearDown {
    
    [super tearDown];
}

- (void)test1Eq1 {
    NSString *input = @"1 eq 1";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0EqEqSignNeg0 {
    NSString *input = @"0 == -0";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0EqEqSign0 {
    NSString *input = @"-0 == 0";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)testNeg0EqEqSignNeg0 {
    NSString *input = @"-0==-0";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqEqSign1 {
    NSString *input = @"1 == 1";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Eq2 {
    NSString *input = @"1 eq 2";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1EqEqSign2 {
    NSString *input = @"1 == 2";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne1 {
    NSString *input = @"1 ne 1";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign1 {
    NSString *input = @"1 != 1";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1Ne2 {
    NSString *input = @"1 ne 2";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test1NeSign2 {
    NSString *input = @"1 != 2";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0EqNeg0 {
    NSString *input = @"0 == -0";
    
    TDEquals(0, -0);
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test0NeNeg0 {
    NSString *input = @"0 != -0";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test00EqNeg00 {
    NSString *input = @"0.0 == -0.0";
    
    TDEquals(0.0, -0.0);
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDTrue([[expr simplify] evaluateAsBooleanInContext:nil]);
}

- (void)test00NeNeg00 {
    NSString *input = @"0.0 != -0.0";
    
    NSError *err = nil;
    XPExpression *expr = [self expressionFromString:input error:&err];
    TDNil(err);
    TDNotNil(expr);
    TDFalse([[expr simplify] evaluateAsBooleanInContext:nil]);
}

@end
