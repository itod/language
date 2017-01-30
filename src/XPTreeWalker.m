//
//  XPTreeWalker.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalker.h"
#import "XPParser.h"
#import "XPNode.h"

@implementation XPTreeWalker

- (void)dealloc {
    self.globalScope = nil;
    self.globals = nil;
    self.currentSpace = nil;
    
    [super dealloc];
}


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
    for (XPNode *stat in node.children) {
        [self walk:stat];
    }
}


- (void)variable:(XPNode *)node {}
- (void)assign:(XPNode *)node {}

@end
