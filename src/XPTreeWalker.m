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
#pragma mark XPTreeWalker

- (XPValue *)loadVariableReference:(XPNode *)node {
    XPValue *res = [self _loadVariableReference:node];
    if (!res) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"unknown var reference: `%@`", node.token.stringValue];
    }
    return res;
}


- (XPValue *)_loadVariableReference:(XPNode *)node {
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

// DECLARATIONS
        case XP_TOKEN_KIND_SUB:
            [self funcDecl:node];
            break;
        case XP_TOKEN_KIND_VAR:
            [self varDecl:node];
            break;
        
// ASSIGNMENTS
        case XP_TOKEN_KIND_EQUALS:
            [self assign:node];
            break;
        case XP_TOKEN_KIND_ASSIGN_INDEX:
            [self assignIndex:node];
            break;
        case XP_TOKEN_KIND_ASSIGN_APPEND:
            [self assignAppend:node];
            break;
            
// FUNCTIONS
        case XP_TOKEN_KIND_CALL:
            res = [self funcCall:node];
            break;
        case XP_TOKEN_KIND_RETURN:
            [self returnStat:node];
            break;

// LOOPS
        case XP_TOKEN_KIND_WHILE:
            [self whileBlock:node];
            break;
        case XP_TOKEN_KIND_IF:
            res = [self ifBlock:node];
            break;
        case XP_TOKEN_KIND_ELSE:
            [self elseBlock:node];
            break;

// UNARY EXPR
        case XP_TOKEN_KIND_NOT:
            res = [self not:node];
            break;
        case XP_TOKEN_KIND_NEG:
            res = [self neg:node];
            break;
        case XP_TOKEN_KIND_LOAD:
            res = [self load:node];
            break;
        case XP_TOKEN_KIND_LOAD_INDEX:
            res = [self index:node];
            break;
            
// BINARY EXPR
        case XP_TOKEN_KIND_OR:
            res = [self or:node];
            break;
        case XP_TOKEN_KIND_AND:
            res = [self and:node];
            break;

        case XP_TOKEN_KIND_EQ:
            res = [self eq:node];
            break;
        case XP_TOKEN_KIND_NE:
            res = [self ne:node];

        case XP_TOKEN_KIND_LT:
            res = [self lt:node];
            break;
        case XP_TOKEN_KIND_LE:
            res = [self le:node];
            break;
        case XP_TOKEN_KIND_GT:
            res = [self gt:node];
            break;
        case XP_TOKEN_KIND_GE:
            res = [self ge:node];
            break;

        case XP_TOKEN_KIND_PLUS:
            res = [self plus:node];
            break;
        case XP_TOKEN_KIND_MINUS:
            res = [self minus:node];
            break;
        case XP_TOKEN_KIND_TIMES:
            res = [self times:node];
            break;
        case XP_TOKEN_KIND_DIV:
            res = [self div:node];
            break;
        case XP_TOKEN_KIND_MOD:
            res = [self mod:node];
            break;

        default:
            res = node;
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
- (void)funcDecl:(XPNode *)node {}

- (void)assign:(XPNode *)node {}
- (void)assignIndex:(XPNode *)node {}
- (void)assignAppend:(XPNode *)node {}

- (id)funcCall:(XPNode *)node {return nil;}
- (void)returnStat:(XPNode *)node {}

- (void)whileBlock:(XPNode *)node {}
- (id)ifBlock:(XPNode *)node {return nil;}
- (void)elseBlock:(XPNode *)node {}

- (id)or:(XPNode *)node {return nil;}
- (id)and:(XPNode *)node {return nil;}

- (id)eq:(XPNode *)node {return nil;}
- (id)ne:(XPNode *)node {return nil;}

- (id)lt:(XPNode *)node {return nil;}
- (id)le:(XPNode *)node {return nil;}
- (id)gt:(XPNode *)node {return nil;}
- (id)ge:(XPNode *)node {return nil;}

- (id)plus:(XPNode *)node {return nil;}
- (id)minus:(XPNode *)node {return nil;}
- (id)times:(XPNode *)node {return nil;}
- (id)div:(XPNode *)node {return nil;}
- (id)mod:(XPNode *)node {return nil;}

- (id)not:(XPNode *)node {return nil;}
- (id)neg:(XPNode *)node {return nil;}
- (id)load:(XPNode *)node {return nil;}
- (id)index:(XPNode *)node {return nil;}
@end
