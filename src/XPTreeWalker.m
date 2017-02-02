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
#import "XPException.h"

@implementation XPTreeWalker

- (void)dealloc {
    self.globalScope = nil;
    self.globals = nil;
    self.currentSpace = nil;
    
    [super dealloc];
}


- (void)raise:(NSString *)name node:(XPNode *)node format:(NSString *)fmt, ... {
    va_list vargs;
    va_start(vargs, fmt);
    
    NSString *reason = [[[NSString alloc] initWithFormat:fmt arguments:vargs] autorelease];
    
    va_end(vargs);

    XPException *ex = [[[XPException alloc] initWithName:name reason:reason userInfo:nil] autorelease];
    ex.lineNumber = node.token.lineNumber;
    ex.range = NSMakeRange(node.token.offset, [node.token.stringValue length]);
    [ex raise];
}


- (void)walk:(XPNode *)node {
    switch (node.token.tokenKind) {
        case XP_TOKEN_KIND_BLOCK:
            [self block:node];
            break;
        case XP_TOKEN_KIND_VAR:
            [self varDecl:node];
            break;
        case XP_TOKEN_KIND_EQUALS:
            [self assign:node];
            break;
        case XP_TOKEN_KIND_SUB:
            [self funcDecl:node];
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


- (void)varDecl:(XPNode *)node {}
- (void)assign:(XPNode *)node {}

- (void)funcDecl:(XPNode *)node {

}

@end
