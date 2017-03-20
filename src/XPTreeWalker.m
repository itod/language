//
//  XPTreeWalker.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPTreeWalker.h>
#import "XPParser.h"
#import "XPNode.h"
#import "XPException.h"
#import <Language/XPObject.h>
#import "XPFunctionSpace.h"
#import "XPFunctionSymbol.h"
#import "XPInterpreter.h"
#import "XPStackFrame.h"

#import <Language/XPBreakpoint.h>
#import <Language/XPBreakpointCollection.h>

@implementation XPTreeWalker

- (instancetype)init {
    self = [self initWithDelegate:nil];
    return self;
}


- (instancetype)initWithDelegate:(id <XPTreeWalkerDelegate>)d {
    self = [super init];
    if (self) {
        self.delegate = d;
        self.callStack = [NSMutableArray array];
        self.lexicalStack = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.globalScope = nil;
    self.globals = nil;
    self.currentSpace = nil;
    self.closureSpace = nil;
    self.stdOut = nil;
    self.stdErr = nil;
    self.callStack = nil;
    self.lexicalStack = nil;
    self.delegate = nil;
    self.breakpointCollection = nil;
    self.currentFilePath = nil;
    
    [super dealloc];
}


#pragma mark -
#pragma mark XPTreeWalker

- (XPObject *)loadVariableReference:(XPNode *)node {
    XPObject *res = [self _loadVariableReference:node];
    
    // TODO REALLY??? FWD indirect func refs
    if (!res) {
        NSString *name = node.token.stringValue;
        TDAssert(node.scope);

        XPFunctionSymbol *funcSym = (id)[node.scope resolveSymbolNamed:name];
        if (funcSym) {
            TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
            if (funcSym.provisionalObject) {
                res = funcSym.provisionalObject;
            } else {
                res = [XPObject function:funcSym];
                funcSym.provisionalObject = res;
            }
        }
    }

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
    XPMemorySpace *res = nil;
    
    // check local or func
    TDAssert(_currentSpace);
    XPMemorySpace *space = _currentSpace;
    do {
        if ([space containsObjectForName:name]) {
            res = space;
            break;
        } else {
            space = space.enclosingSpace;
        }
    } while (space);
    
    // if in local, check func too
    TDAssert(_callStack);
    if (!res && [_callStack count] && [_callStack lastObject] != _currentSpace && [[_callStack lastObject] containsObjectForName:name]) {
        res = [_callStack lastObject];
    }
    
    // if present, check closure space
    if (!res && _closureSpace != _currentSpace && [_closureSpace containsObjectForName:name]) {
        res = _closureSpace;
    }
    
    // if not currently in global space, check globals
    if (!res && _globals != _currentSpace && [_globals containsObjectForName:name]) {
        res = _globals;
    }
    
    return res;
}


#pragma mark -
#pragma mark Debug Info

- (NSMutableDictionary *)currentDebugInfo:(NSUInteger)lineNum {
    TDAssert(_debug);
    TDAssert(_currentFilePath);
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];

    // file path
    {
        TDAssert(_currentFilePath);
        info[XPDebugInfoFilePathKey] = _currentFilePath;
        
    }

    // frame stack
    {
        NSUInteger c = [self.callStack count];
        
        NSMutableArray *frameStack = [NSMutableArray arrayWithCapacity:c];
        [info setObject:frameStack forKey:XPDebugInfoFrameStackKey];
        
        for (XPMemorySpace *space in [self.callStack reverseObjectEnumerator]) {
            XPStackFrame *frame = [[[XPStackFrame alloc] init] autorelease];
            frame.lineNumber = space.lineNumber;
            frame.filePath = _currentFilePath;
            frame.functionName = space.name;
            [frame setMembers:space.members];
            
            [frameStack addObject:frame];
        }
        
        [[frameStack firstObject] setLineNumber:lineNum];
        
        // add global space manually
        {
            XPStackFrame *frame = [[[XPStackFrame alloc] init] autorelease];
            frame.lineNumber = self.globals.lineNumber;
            frame.filePath = _currentFilePath;
            frame.functionName = @"<global>";
            [frame setMembers:self.globals.members];
            
            [frameStack addObject:frame];
        }
    }
    
    return info;
}


#pragma mark -
#pragma mark Walker

- (void)raise:(NSString *)name node:(XPNode *)node format:(NSString *)fmt, ... {
    va_list vargs;
    va_start(vargs, fmt);
    
    NSString *reason = [[[NSString alloc] initWithFormat:fmt arguments:vargs] autorelease];
    
    va_end(vargs);

    XPException *ex = [[[XPException alloc] initWithName:name reason:reason userInfo:nil] autorelease];
    ex.lineNumber = node.lineNumber;
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

// REFERENCES
        case XP_TOKEN_KIND_LOAD:            res = [self load:node]; break;
        case XP_TOKEN_KIND_LOAD_SUBSCRIPT:  res = [self loadSubscript:node]; break;

// ASSIGNMENTS
        case XP_TOKEN_KIND_EQUALS:          [self assign:node]; break;
        case XP_TOKEN_KIND_SAVE_SUBSCRIPT:  [self saveSubscript:node]; break;
        case XP_TOKEN_KIND_APPEND:          [self append:node]; break;
            
        case XP_TOKEN_KIND_PLUSEQ:          [self plusEq:node]; break;
        case XP_TOKEN_KIND_MINUSEQ:         [self minusEq:node]; break;
        case XP_TOKEN_KIND_TIMESEQ:         [self timesEq:node]; break;
        case XP_TOKEN_KIND_DIVEQ:           [self divEq:node]; break;

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
        case XP_TOKEN_KIND_BITNOT:          res = [self bitNot:node]; break;
            
// BINARY EXPR
        case XP_TOKEN_KIND_AND:             res = [self and:node]; break;
        case XP_TOKEN_KIND_OR:              res = [self or:node]; break;

        case XP_TOKEN_KIND_BITAND:          res = [self bitAnd:node]; break;
        case XP_TOKEN_KIND_BITOR:           res = [self bitOr:node]; break;
        case XP_TOKEN_KIND_BITXOR:          res = [self bitXor:node]; break;

        case XP_TOKEN_KIND_SHIFTLEFT:       res = [self shiftLeft:node]; break;
        case XP_TOKEN_KIND_SHIFTRIGHT:      res = [self shiftRight:node]; break;

        case XP_TOKEN_KIND_EQ:              res = [self eq:node]; break;
        case XP_TOKEN_KIND_NE:              res = [self ne:node]; break;
        case XP_TOKEN_KIND_IS:              res = [self is:node]; break;
            
        case XP_TOKEN_KIND_LT:              res = [self lt:node]; break;
        case XP_TOKEN_KIND_LE:              res = [self le:node]; break;
        case XP_TOKEN_KIND_GT:              res = [self gt:node]; break;
        case XP_TOKEN_KIND_GE:              res = [self ge:node]; break;
            
        case XP_TOKEN_KIND_PLUS:            res = [self plus:node]; break;
        case XP_TOKEN_KIND_MINUS:           res = [self minus:node]; break;
        case XP_TOKEN_KIND_TIMES:           res = [self times:node]; break;
        case XP_TOKEN_KIND_DIV:             res = [self div:node]; break;
        case XP_TOKEN_KIND_MOD:             res = [self mod:node]; break;

        case XP_TOKEN_KIND_CAT:             res = [self concat:node]; break;

// NULL
        case XP_TOKEN_KIND_NULL:            res = [self null:node]; break;
// NaN
        case XP_TOKEN_KIND_NAN:             res = [self nan:node]; break;
// BOOLEAN
        case XP_TOKEN_KIND_TRUE:            res = [self trueNode:node]; break;
        case XP_TOKEN_KIND_FALSE:           res = [self falseNode:node]; break;
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
        self.currentSpace = [[[XPMemorySpace alloc] initWithName:@"LOCAL" enclosingSpace:savedSpace] autorelease];
    } else {
        // top-level
        self.currentSpace = _globals;
    }
    TDAssert(_currentSpace);
    
    for (NSString *name in vars) {
        XPObject *obj = vars[name];
        [_currentSpace setObject:obj forName:name];
    }
    
    
    [self doWalkStats:node];
    
    self.currentSpace = savedSpace;
}


// no new mem space is necessary for func blocks. it's already been created and filled with args
- (void)funcBlock:(XPNode *)node {
    TDAssert([_currentSpace isKindOfClass:[XPFunctionSpace class]]);
    [self doWalkStats:node];
}


- (void)doWalkStats:(XPNode *)node {
    for (XPNode *stat in node.children) {
        if (_debug) {
            BOOL shouldPause = self.currentSpace.wantsPause;
            NSUInteger lineNum = stat.lineNumber; // checks recursively
            
            if (!shouldPause) {
                shouldPause = [self shouldPauseAtLineNumber:lineNum];
            }
            
            if (shouldPause) {
                NSMutableDictionary *info = [self currentDebugInfo:lineNum];
                info[XPDebugInfoLineNumberKey] = @(lineNum);
                [self.delegate treeWalker:self didPause:info];
            }
        }

        [self walk:stat];
    }
}


- (BOOL)shouldPauseAtLineNumber:(NSUInteger)lineNum {
    TDAssert(_debug);
    
    BOOL res = NO;
    
    TDAssert(_currentFilePath);
    TDAssert(_breakpointCollection)
    for (XPBreakpoint *bp in [_breakpointCollection breakpointsForFile:_currentFilePath]) {
        if (bp.enabled && lineNum == bp.lineNumber) {
            res = YES;
            break;
        }
    }
    
    return res;
}


- (void)stat:(XPNode *)node {}

- (void)varDecl:(XPNode *)node {}
- (void)funcDecl:(XPNode *)node {}

- (void)assign:(XPNode *)node {}
- (void)plusEq:(XPNode *)node {}
- (void)minusEq:(XPNode *)node {}
- (void)timesEq:(XPNode *)node {}
- (void)divEq:(XPNode *)node {}
- (void)saveSubscript:(XPNode *)node {}
- (void)append:(XPNode *)node {}

- (id)call:(XPNode *)node {return nil;}
- (void)returnStat:(XPNode *)node {}

- (void)whileBlock:(XPNode *)node {}
- (void)forBlock:(XPNode *)node {}
- (id)ifBlock:(XPNode *)node {return nil;}
- (void)elseBlock:(XPNode *)node {}
- (void)breakNode:(XPNode *)node {}
- (void)continueNode:(XPNode *)node {}

- (id)and:(XPNode *)node {return nil;}
- (id)or:(XPNode *)node {return nil;}

- (id)bitAnd:(XPNode *)node {return nil;}
- (id)bitOr:(XPNode *)node {return nil;}
- (id)bitXor:(XPNode *)node {return nil;}
- (id)bitNot:(XPNode *)node {return nil;}

- (id)shiftLeft:(XPNode *)node {return nil;}
- (id)shiftRight:(XPNode *)node {return nil;}

- (id)eq:(XPNode *)node {return nil;}
- (id)ne:(XPNode *)node {return nil;}
- (id)is:(XPNode *)node {return nil;}

- (id)lt:(XPNode *)node {return nil;}
- (id)le:(XPNode *)node {return nil;}
- (id)gt:(XPNode *)node {return nil;}
- (id)ge:(XPNode *)node {return nil;}

- (id)plus:(XPNode *)node {return nil;}
- (id)minus:(XPNode *)node {return nil;}
- (id)times:(XPNode *)node {return nil;}
- (id)div:(XPNode *)node {return nil;}
- (id)mod:(XPNode *)node {return nil;}

- (id)concat:(XPNode *)node {return nil;}

- (id)not:(XPNode *)node {return nil;}
- (id)neg:(XPNode *)node {return nil;}
- (id)load:(XPNode *)node {return nil;}
- (id)loadSubscript:(XPNode *)node {return nil;}

- (id)null:(XPNode *)node {return nil;}
- (id)nan:(XPNode *)node {return nil;}
- (id)trueNode:(XPNode *)node {return nil;}
- (id)falseNode:(XPNode *)node {return nil;}
- (id)number:(XPNode *)node {return nil;}
- (id)string:(XPNode *)node {return nil;}
- (id)array:(XPNode *)node {return nil;}
- (id)dictionary:(XPNode *)node {return nil;}
- (id)function:(XPNode *)node {return nil;}
@end
