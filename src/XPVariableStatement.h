//
//  XPVariableStatement.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <PEGKit/PEGKit.h>

@class XPExpression;

@interface XPVariableStatement : PKAST
+ (instancetype)variableStatementWithId:(PKToken *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs;
- (instancetype)initWithId:(PKToken *)lhs token:(PKToken *)eq expression:(XPExpression *)rhs;
@end
