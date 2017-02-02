//
//  XPCallExpression.m
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPCallExpression.h"

@implementation XPCallExpression

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
    
    return nil;
}

@end
