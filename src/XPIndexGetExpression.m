//
//  XPIndexGetExpression.m
//  Language
//
//  Created by Todd Ditchendorf on 2/5/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPIndexGetExpression.h"
#import "XPValue.h"

@implementation XPIndexGetExpression

- (instancetype)initWithToken:(PKToken *)tok {
    self = [super initWithToken:tok];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}


- (XPValue *)evaluateInContext:(id <XPContext>)ctx {
    TDAssert(ctx);
    
    XPExpression *qidExpr = [ctx loadVariableReference:self];
    XPValue *arrVal = [qidExpr evaluateInContext:ctx];
    
    if (![arrVal isArrayValue]) {
        @throw @"TODO";
        return nil;
    }
    
    NSUInteger idx = [[self childAtIndex:0] evaluateAsNumberInContext:ctx];

    XPExpression *resExpr = [arrVal childAtIndex:idx];
    XPValue *resVal = [resExpr evaluateInContext:ctx];
    
    return resVal;
}

@end
