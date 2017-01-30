//
//  XPTreeWalkerDecl.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerDecl.h"
#import "XPMemorySpace.h"
#import "XPParser.h"
#import "XPNode.h"
#import "XPValue.h" // REMOVE ME

@implementation XPTreeWalkerDecl

- (void)walk:(XPNode *)node {
    
    switch (node.token.tokenKind) {
        case XP_TOKEN_KIND_BLOCK:
            [self block:node];
            break;
        case XP_TOKEN_KIND_VAR:
            [self variable:node];
            break;
        default:
            TDAssert(0);
            break;
    }
}


- (void)block:(XPNode *)node {
    TDAssert(XP_TOKEN_KIND_BLOCK == node.token.tokenKind);
    
    for (XPNode *stat in node.children) {
        [self walk:stat];
    }
}


- (void)variable:(XPNode *)node {
    TDAssert(XP_TOKEN_KIND_VAR == node.token.tokenKind);
    
    NSString *name = [[node.children[0] token] stringValue];
    XPExpression *expr = node.children[1];
    XPValue *val = [expr evaluateInContext:nil];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}

@end
