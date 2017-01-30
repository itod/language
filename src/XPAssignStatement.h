//
//  XPAssignStatement.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPStatement.h>

@class XPToken;
@class XPExpression;

@interface XPAssignStatement : XPStatement
+ (instancetype)assignStatementWithId:(XPNode *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs;
- (instancetype)initWithId:(XPNode *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs;
@end
