//
//  XPAssignStatement.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPAssignStatement.h"
#import <Language/XPExpression.h>

@implementation XPAssignStatement

+ (instancetype)assignStatementWithId:(XPNode *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs {
    return [[[self alloc] initWithId:lhs token:eq expression:rhs] autorelease];
}


- (instancetype)initWithId:(XPNode *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs {
    self = [self initWithToken:eq];
    if (self) {
        [self addChild:lhs];
        [self addChild:rhs];
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}

@end
