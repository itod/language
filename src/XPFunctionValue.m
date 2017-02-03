//
//  XPFunctionValue.m
//  Language
//
//  Created by Todd Ditchendorf on 03.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionValue.h"

@implementation XPFunctionValue

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
//    TDAssert(ctx);
//    
//    XPNode *block = [self childAtIndex:1];
//    XPExpression *expr = [ctx walk:block];
//    XPValue *val = [expr evaluateInContext:ctx];
//    if (!val) {
//        val = [XPValue nullValue];
//    }
//    return val;
    return self;
}

@end
