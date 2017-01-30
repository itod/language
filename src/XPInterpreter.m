//
//  XPInterpreter.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPInterpreter.h"
#import "XPGlobalScope.h"
#import "XPMemorySpace.h"
#import "XPParser.h"
#import "XPNode.h"
#import "XPStatement.h"
#import "XPExpression.h"

#define TOKEN_KIND_BLOCK -2

@implementation XPInterpreter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.globals = [[[XPMemorySpace alloc] initWithName:@"globals"] autorelease];       // global memory
        self.currentSpace = _globals;
    }
    return self;
}


- (void)interpretString:(NSString *)input error:(NSError **)outErr {
    self.globalScope = [[[XPGlobalScope alloc] init] autorelease];
    self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
    
    NSError *err = nil;
    PKAssembly *a = [_parser parseString:input error:&err];
    TDAssert(a);

    self.root = [a pop];
    
    if (!_root) {
        *outErr = err;
        return;
    }

    [self block:_root];
}


- (void)exec:(XPNode *)node {
    
    switch (node.token.tokenKind) {
        case TOKEN_KIND_BLOCK:
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
    TDAssert([node.token.stringValue isEqualToString:@"BLOCK"]);
    
    for (XPNode *stat in node.children) {
        [self exec:stat];
    }
}


- (void)variable:(XPNode *)node {
    TDAssert(XP_TOKEN_KIND_VAR == node.token.tokenKind);
    
    NSString *name = [[node.children[0] token] stringValue];
    XPExpression *expr = node.children[1];
    XPValue *val = [expr evaluateInContext:self];
    
    TDAssert(_currentSpace);
    [_currentSpace setObject:val forName:name];
    
}

@end
