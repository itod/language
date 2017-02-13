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
#import "XPObject.h"
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

- (XPObject *)loadVariableReference:(XPNode *)node {
    XPObject *res = [self _loadVariableReference:node];
    if (!res) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"unknown var reference: `%@`", node.token.stringValue];
    }
    return res;
}


- (XPObject *)_loadVariableReference:(XPNode *)node {
    NSString *name = node.token.stringValue;
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    XPObject *res = [space objectForName:name];
    return res;
}


- (XPMemorySpace *)spaceWithSymbolNamed:(NSString *)name {
    XPMemorySpace *space = nil;
    
    // check local or func
    TDAssert(_currentSpace);
    if ([_currentSpace objectForName:name]) {
        space = _currentSpace;
    }
    
    // if in local, check func too
    TDAssert(_stack);
    if (!space && [_stack count] && [_stack lastObject] != _currentSpace && [[_stack lastObject] objectForName:name]) {
        space = [_stack lastObject];
    }
    
    // if not currently in global space, check globals
    if (!space && _globals != _currentSpace && [_globals objectForName:name]) {
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

        case XP_TOKEN_KIND_BLOCK:           [self block:node]; break;

// DECLARATIONS
        case XP_TOKEN_KIND_VAR:             [self varDecl:node]; break;
        case XP_TOKEN_KIND_SUB:             [self funcDecl:node]; break;
            
// ASSIGNMENTS
        case XP_TOKEN_KIND_EQUALS:          [self assign:node]; break;
        case XP_TOKEN_KIND_ASSIGN_SUBSCRIPT:[self assignSubscript:node]; break;
        case XP_TOKEN_KIND_ASSIGN_APPEND:   [self assignAppend:node]; break;
            
// FUNCTIONS
        case XP_TOKEN_KIND_CALL:            res = [self call:node]; break;
        case XP_TOKEN_KIND_RETURN:          [self returnStat:node]; break;
            
// LOOPS
        case XP_TOKEN_KIND_WHILE:           [self whileBlock:node]; break;
        case XP_TOKEN_KIND_FOR:             [self forBlock:node]; break;
        case XP_TOKEN_KIND_IF:              res = [self ifBlock:node]; break;
        case XP_TOKEN_KIND_ELSE:            [self elseBlock:node]; break;
        case XP_TOKEN_KIND_BREAK:           [self breakNode:node]; break;
        case XP_TOKEN_KIND_CONTINUE:        [self continueNode:node]; break;
            
// UNARY EXPR
        case XP_TOKEN_KIND_NOT:             res = [self not:node]; break;
        case XP_TOKEN_KIND_NEG:             res = [self neg:node]; break;
        case XP_TOKEN_KIND_LOAD:            res = [self load:node]; break;
        case XP_TOKEN_KIND_LOAD_INDEX:      res = [self loadIndex:node]; break;
            
// BINARY EXPR
        case XP_TOKEN_KIND_OR:              res = [self or:node]; break;
        case XP_TOKEN_KIND_AND:             res = [self and:node]; break;
            
        case XP_TOKEN_KIND_EQ:              res = [self eq:node]; break;
        case XP_TOKEN_KIND_NE:              res = [self ne:node]; break;
            
        case XP_TOKEN_KIND_LT:              res = [self lt:node]; break;
        case XP_TOKEN_KIND_LE:              res = [self le:node]; break;
        case XP_TOKEN_KIND_GT:              res = [self gt:node]; break;
        case XP_TOKEN_KIND_GE:              res = [self ge:node]; break;
            
        case XP_TOKEN_KIND_PLUS:            res = [self plus:node]; break;
        case XP_TOKEN_KIND_MINUS:           res = [self minus:node]; break;
        case XP_TOKEN_KIND_TIMES:           res = [self times:node]; break;
        case XP_TOKEN_KIND_DIV:             res = [self div:node]; break;
        case XP_TOKEN_KIND_MOD:             res = [self mod:node]; break;

// NULL
        case XP_TOKEN_KIND_NULL:            res = [self null:node]; break;
// BOOLEAN
        case XP_TOKEN_KIND_TRUE:
        case XP_TOKEN_KIND_FALSE:           res = [self boolean:node]; break;
// NUMBER
        case TOKEN_KIND_BUILTIN_NUMBER:     res = [self number:node]; break;
// STRING
        case TOKEN_KIND_BUILTIN_WORD:       res = [self string:node]; break;
// ARRAY
        case XP_TOKEN_KIND_ARRAY_LITERAL:   res = [self array:node]; break;
// DICT
        case XP_TOKEN_KIND_DICT_LITERAL:    res = [self dictionary:node]; break;
// FUNCTION
        case XP_TOKEN_KIND_FUNC_LITERAL:    res = [self function:node]; break;

        default:
            res = node;
            break;
    }
    
    return res;
}


- (void)block:(XPNode *)node {
    [self block:node withVars:nil];
}


- (void)block:(XPNode *)node withVars:(NSDictionary<NSString *, XPObject *> *)vars {
    XPMemorySpace *savedSpace = _currentSpace;

    if (_currentSpace) {
        // func or local
        self.currentSpace = [[[XPMemorySpace alloc] initWithName:@"LOCAL"] autorelease];
    } else {
        // top-level
        self.currentSpace = _globals;
    }
    TDAssert(_currentSpace);
    
    for (NSString *name in vars) {
        XPObject *obj = vars[name];
        [_currentSpace setObject:obj forName:name];
    }
    
    for (XPNode *stat in node.children) {
        [self walk:stat];
    }
    
    self.currentSpace = savedSpace;
}


// no new mem space is necessary for func blocks. it's already been created and filled with args
- (void)funcBlock:(XPNode *)node {
    TDAssert([_currentSpace isKindOfClass:[XPFunctionSpace class]]);
    for (XPNode *stat in node.children) {
        [self walk:stat];
    }
}


- (void)varDecl:(XPNode *)node {}
- (void)funcDecl:(XPNode *)node {}

- (void)assign:(XPNode *)node {}
- (void)assignSubscript:(XPNode *)node {}
- (void)assignAppend:(XPNode *)node {}

- (id)call:(XPNode *)node {return nil;}
- (void)returnStat:(XPNode *)node {}

- (void)whileBlock:(XPNode *)node {}
- (void)forBlock:(XPNode *)node {}
- (id)ifBlock:(XPNode *)node {return nil;}
- (void)elseBlock:(XPNode *)node {}
- (void)breakNode:(XPNode *)node {}
- (void)continueNode:(XPNode *)node {}

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
- (id)loadIndex:(XPNode *)node {return nil;}

- (id)null:(XPNode *)node {return nil;}
- (id)boolean:(XPNode *)node {return nil;}
- (id)number:(XPNode *)node {return nil;}
- (id)string:(XPNode *)node {return nil;}
- (id)array:(XPNode *)node {return nil;}
- (id)dictionary:(XPNode *)node {return nil;}
- (id)function:(XPNode *)node {return nil;}
@end
