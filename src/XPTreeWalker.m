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
#import "XPValue.h"
#import "XPFunctionSpace.h"

@implementation XPTreeWalker

- (instancetype)init {
    self = [super init];
    if (self) {
        self.stack = [NSMutableArray array];
   }
    return self;
}


- (void)dealloc {
    self.globalScope = nil;
    self.globals = nil;
    self.currentSpace = nil;
    self.stack = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark XPContext

- (id)loadVariableReference:(XPNode *)node {
    id res = [self _loadVariableReference:node];
    if (!res) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"unknown var reference: `%@`", node.token.stringValue];
    }
    return res;
}


- (id)_loadVariableReference:(XPNode *)node {
    NSString *name = node.token.stringValue;
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    id res = [space objectForName:name];
    return res;
}


- (XPMemorySpace *)spaceWithSymbolNamed:(NSString *)name {
    XPMemorySpace *space = nil;
    
    TDAssert(_stack);
    if ([_stack count] && [[_stack lastObject] objectForName:name]) {
        space = [_stack lastObject];
    }
    
    if (!space && [_globals objectForName:name]) {
        space = _globals;
    }
    
    return space;
}


#pragma mark -
#pragma mark Walker

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


- (id)walk:(XPNode *)node {
    
    id res = nil;
    
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
        case XP_TOKEN_KIND_RETURN:
            [self returnStat:node];
            break;
        case XP_TOKEN_KIND_WHILE:
            [self whileBlock:node];
            break;
        case XP_TOKEN_KIND_IF:
            res = [self ifBlock:node];
            break;
        case XP_TOKEN_KIND_ELSE:
            [self elseBlock:node];
            break;
        
        case XP_TOKEN_KIND_CALL:
            res = [self funcCall:node];
            break;

        default:
            TDAssert([node isKindOfClass:[XPExpression class]]);
            res = [(id)node evaluateInContext:self];
            break;
    }
    
    return res;
}


- (void)block:(XPNode *)node {
    for (XPNode *stat in node.children) {
        [self walk:stat];
    }
}


- (void)varDecl:(XPNode *)node {}
- (void)assign:(XPNode *)node {}
- (void)funcDecl:(XPNode *)node {}
- (id)funcCall:(XPNode *)node { return nil; }
- (void)returnStat:(XPNode *)node {}
- (void)whileBlock:(XPNode *)node {}
- (id)ifBlock:(XPNode *)node {return nil;}
- (void)elseBlock:(XPNode *)node {}

@end
