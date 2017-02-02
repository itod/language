//
//  XPRefExpression.m
//  Language
//
//  Created by Todd Ditchendorf on 02.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPRefExpression.h"
#import "XPContext.h"

@implementation XPRefExpression

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
    
    XPExpression *expr = [ctx loadVariableReference:self];
    XPValue *val = [expr evaluateInContext:ctx];
    return val;
}

@end
