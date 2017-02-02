//
//  XPTreeWalkerEval.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerEval.h"
#import "XPMemorySpace.h"
#import "XPNode.h"
#import "XPExpression.h"
#import "XPValue.h"
#import "XPException.h"

@implementation XPTreeWalkerEval

- (void)varDecl:(XPNode *)node {
    NSString *name = [[[node childAtIndex:0] token] stringValue];
    XPExpression *expr = [node childAtIndex:1];
    XPValue *val = [expr evaluateInContext:nil];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}


- (void)assign:(XPNode *)node {
    XPNode *idNode = [node childAtIndex:0];
    NSString *name = idNode.token.stringValue;
    
    if (![self.currentSpace objectForName:name]) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    XPExpression *expr = [node childAtIndex:1];
    XPValue *val = [expr evaluateInContext:nil];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}

@end
