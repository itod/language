//
//  XPVariableStatement.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPVariableStatement.h"
#import <PEGKit/PKToken.h>
#import <Language/XPExpression.h>

@implementation XPVariableStatement

+ (instancetype)variableStatementWithId:(XPNode *)lhs token:(PKToken *)tok expression:(XPExpression *)rhs {
    return [[[self alloc] initWithId:lhs token:tok expression:rhs] autorelease];
}


- (instancetype)initWithId:(XPNode *)lhs token:(PKToken *)tok expression:(XPExpression *)rhs {
    self = [self initWithToken:tok];
    if (self) {
        [self addChild:lhs];
        [self addChild:rhs];
    }
    return self;
}

@end
