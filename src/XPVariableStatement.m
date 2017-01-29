//
//  XPVariableStatement.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPVariableStatement.h"
#import <Language/XPExpression.h>

@implementation XPVariableStatement

+ (instancetype)variableStatementWithId:(PKToken *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs {
    return [[[self alloc] initWithId:lhs token:eq expression:rhs] autorelease];
}


- (instancetype)initWithId:(PKToken *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs {
    self = [super init];
    if (self) {
        self.token = eq;
        self.children[0] = lhs;
        self.children[1] = lhs;
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}

@end
