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

+ (instancetype)assignStatementWithId:(PKToken *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs {
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
