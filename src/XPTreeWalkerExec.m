//
//  XPTreeWalkerExec.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerExec.h"
#import <Language/XPUserThrownException.h>
#import "XPIndexException.h"

#import "XPMemorySpace.h"
#import "XPFunctionSpace.h"

#import "XPNode.h"

#import "XPVariableSymbol.h"
#import "XPFunctionSymbol.h"
#import "XPFunctionBody.h"

#import "XPParser.h"

#import <Language/XPObject.h>

#import "XPSymbol.h"

#import "XPEnumeration.h"
#import "XPFlowExceptions.h"

#define OFFSET 1

@interface XPTreeWalkerExec ()
@property (nonatomic, retain) XPReturnExpception *returnException;
@property (nonatomic, retain) XPBreakException *breakException;
@property (nonatomic, retain) XPContinueException *continueException;
@end

@implementation XPTreeWalkerExec

- (instancetype)initWithDelegate:(id <XPTreeWalkerDelegate>)d {
    self = [super initWithDelegate:d];
    if (self) {
        self.returnException = [[[XPReturnExpception alloc] initWithName:@"return" reason:nil userInfo:nil] autorelease];
        self.breakException = [[[XPBreakException alloc] initWithName:@"break" reason:nil userInfo:nil] autorelease];
        self.continueException = [[[XPContinueException alloc] initWithName:@"continue" reason:nil userInfo:nil] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.returnException = nil;
    self.breakException = nil;
    self.continueException = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark DECL

- (void)varDecl:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    NSString *name = [[[node childAtIndex:0] token] stringValue];
    
    if ([[XPSymbol reservedWords] containsObject:name]) {
        [self raise:XPNameError node:node format:@"cannot define variable with reserved name `%@`", name];
        return;
    }
    
    TDAssert(self.currentSpace);
    if ([self.currentSpace.members objectForKey:name]) {
        [self raise:XPNameError node:node format:@"cannot re-define variable with same name (`%@`) within same scope", name];
        return;
    }
    
    XPNode *expr = [node childAtIndex:1];
    XPObject *valObj = [self walk:expr];
    TDAssert([valObj isKindOfClass:[XPObject class]]);
    
    [self.currentSpace setObject:valObj forName:name];
}


- (void)funcDecl:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (sub make (BLOCK (return [)))

    XPNode *nameNode = [node childAtIndex:0];
    NSString *name = nameNode.name;

    if ([[XPSymbol reservedWords] containsObject:name]) {
        [self raise:XPNameError node:node format:@"cannot define subroutine with reserved name `%@`", name];
        return;
    }

    TDAssert([nameNode.scope conformsToProtocol:@protocol(XPScope)]);
    XPFunctionSymbol *funcSym = (id)[nameNode.scope resolveSymbolNamed:name];
    TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
    XPObject *obj = [XPObject function:funcSym];
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:obj forName:name];
    funcSym.closureSpace = self.currentSpace;
}


- (void)evalDefaultParams:(XPFunctionSymbol *)funcSym {
    if (!funcSym.defaultParamExpressions) return;
    
    for (NSString *name in funcSym.defaultParamExpressions) {
        XPNode *expr = funcSym.defaultParamExpressions[name];
        XPObject *valObj = [self walk:expr];
        [funcSym setDefaultObject:valObj forParamNamed:name];
    }
    
    funcSym.defaultParamExpressions = nil;
}


#pragma mark -
#pragma mark ASSIGN

- (void)assignEq:(XPNode *)node op:(NSInteger)op {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    XPNode *idNode = [node childAtIndex:0];
    NSString *name = idNode.name;
    
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    if (!space) {
        [self raise:XPNameError node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    double lhs = [[space objectForName:name] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = 0.0;
    switch (op) {
        case XP_TOKEN_KIND_PLUSEQ:
            res = lhs + rhs;
            break;
        case XP_TOKEN_KIND_MINUSEQ:
            res = lhs - rhs;
            break;
        case XP_TOKEN_KIND_TIMESEQ:
            res = lhs * rhs;
            break;
        case XP_TOKEN_KIND_DIVEQ:
            res = lhs / rhs;
            break;
        default:
            TDAssert(0);
            break;
    }

    XPObject *valObj = [XPObject number:res];
    [space setObject:valObj forName:name];
}


- (void)plusEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_PLUSEQ]; }
- (void)minusEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_MINUSEQ]; }
- (void)timesEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_TIMESEQ]; }
- (void)divEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_DIVEQ]; }


- (void)assign:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    XPNode *idNode = [node childAtIndex:0];
    NSString *name = idNode.name;
    
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    if (!space) {
        [self raise:XPNameError node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    XPNode *expr = [node childAtIndex:1];
    XPObject *valObj = [self walk:expr];
    
    [space setObject:valObj forName:name];
}


- (id)assign:(XPNode *)node op:(NSInteger)op {
    // (+ `2` `1`)
    
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = 0.0;
    switch (op) {
        case XP_TOKEN_KIND_PLUS:
            res = lhs + rhs;
            break;
        case XP_TOKEN_KIND_MINUS:
            res = lhs - rhs;
            break;
        case XP_TOKEN_KIND_TIMES:
            res = lhs * rhs;
            break;
        case XP_TOKEN_KIND_DIV:
            res = lhs / rhs;
            break;
        case XP_TOKEN_KIND_MOD:
            res = lrint(lhs) % lrint(rhs);
            break;
        default:
            TDAssert(0);
            break;
    }
    
    return [XPObject number:res];
}


- (void)subscriptAssign:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (SUBSCRIPT_ASSIGN lhs rhs start stop?)
    XPNode *idNode = [node childAtIndex:0];
    
    XPObject *collObj = [self loadVariableReference:idNode];
    
    if (!collObj) {
        [self raise:XPNameError node:node format:@"attempting to assign to undeclared symbol `%@`", idNode.name];
        return;
    }
    
    XPNode *valNode = [node childAtIndex:1];
    XPObject *valObj = [self walk:valNode];

#if MUTABLE_STRINGS
    if ([collObj isStringObject] || [collObj isArrayObject]) {
#else
    if ([collObj isArrayObject]) {
#endif
        XPNode *startNode = [node childAtIndex:2];
        NSInteger start = [[self walk:startNode] doubleValue];
        
        NSInteger stop = start;
        if ([node childCount] > 3) {
            XPNode *stopNode = [node childAtIndex:3];
            stop = [[self walk:stopNode] doubleValue];
        }
        
        @try {
            [collObj callInstanceMethodNamed:@"set" withArgs:@[@(start), @(stop), valObj]];
        } @catch (XPIndexException *ex) {
            [self raise:XPIndexError node:node format:ex.reason];
            return;
        }
    }
    
    else if ([collObj isDictionaryObject]) {
        if ([node childCount] > 3) {
            [self raise:XPTypeError node:node format:@"attempting slice assignment on non-Array object: `%@`", idNode.name];
            return;
        }
        
        XPNode *keyNode = [node childAtIndex:2];
        XPObject *keyObj = [self walk:keyNode];
        
        [collObj callInstanceMethodNamed:@"set" withArgs:@[keyObj, valObj]];
    }
    
    else {
        [self raise:XPTypeError node:node format:@"attempting subscript assignment on non-Collection object `%@`", idNode.name];
        return;
    }
}


- (void)append:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (APPEND foo `c`)
    XPNode *idNode = [node childAtIndex:0];
    
    XPObject *seqObj = [self loadVariableReference:idNode];
    
    if (!seqObj) {
        [self raise:XPNameError node:node format:@"attempting to assign to undeclared symbol `%@`", idNode.name];
        return;
    }

#if MUTABLE_STRINGS
    if (![seqObj isStringObject] && ![seqObj isArrayObject]) {
        [self raise:XPTypeError node:node format:@"attempting indexed assignment on non-sequence object `%@`", idNode.name];
        return;
    }
#else
    if (![seqObj isArrayObject]) {
        [self raise:XPTypeError node:node format:@"attempting indexed assignment on non-Array object `%@`", idNode.name];
        return;
    }
#endif
    
    XPNode *valNode = [node childAtIndex:1];
    XPObject *valObj = [self walk:valNode];
    
    [seqObj callInstanceMethodNamed:@"append" withArg:valObj];
}


#pragma mark -
#pragma mark LOAD


- (id)load:(XPNode *)node {
    // (LOAD foo)
    XPNode *idNode = [node childAtIndex:0];
    XPObject *obj = [self loadVariableReference:idNode];
    return obj;
}


- (id)subscriptLoad:(XPNode *)node {
    // (GET_IDX (LOAD foo) `0`)
    XPNode *targetNode = [node childAtIndex:0];
    XPNode *startNode = [node childAtIndex:1];
    XPNode *stopNode = nil;
    XPNode *stepNode = nil;
    
    if ([node childCount] > 2) {
        stopNode = [node childAtIndex:2];
        
        if ([node childCount] > 3) {
            stepNode = [node childAtIndex:3];
        }
    }
    
    XPObject *targetObj = [self walk:targetNode];

    XPObject *res = nil;

    if ([targetObj isStringObject] || [targetObj isArrayObject]) {
        NSInteger start = [[self walk:startNode] doubleValue];
        NSInteger stop = start;
        NSInteger step = 1;
        
        if (stopNode) {
            stop = [[self walk:stopNode] doubleValue];
            if (stepNode) {
                step = [[self walk:stepNode] doubleValue];
            }
        }
        
        @try {
            res = [targetObj callInstanceMethodNamed:@"get" withArgs:@[@(start), @(stop), @(step)]];
        } @catch (XPIndexException *ex) {
            [self raise:XPIndexError node:node format:ex.reason];
            return nil;
        }
    }
    
    else if ([targetObj isDictionaryObject]) {
        if (stopNode) {
            [self raise:XPTypeError node:node format:@"attempting sliced subscript access on non-Array object `%@`", targetNode.name];
            return nil;
        }
        TDAssert(!stepNode);
        XPObject *keyObj = [self walk:startNode];
        
        res = [targetObj callInstanceMethodNamed:@"get" withArg:keyObj];
    }
    
    else {
        [self raise:XPNameError node:node format:@"attempting subscript access on non-collection object `%@`", targetNode.name];
        return nil;
    }
    
    return res;
}


#pragma mark -
#pragma mark LOOPS

- (void)whileBlock:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPNode *block = [node childAtIndex:1];
    
    BOOL b = [[self walk:expr] boolValue];
    while (b) {
        @try {
            [self block:block];
        } @catch (XPBreakException *ex) {
            break;
        } @catch (XPContinueException *ex) {
            // continue on
        }
        b = [[self walk:expr] boolValue];
    }
}


- (void)forBlock:(XPNode *)node {
    XPNode *valNode = [node childAtIndex:0];
    XPNode *collExpr = [node childAtIndex:1];
    XPNode *block = [node childAtIndex:2];
    XPNode *keyNode = nil;
    if ([node childCount] > 3) {
        keyNode = [node childAtIndex:3];
    }
    
    XPObject *collObj = [self walk:collExpr];
    XPEnumeration *e = [collObj enumeration];
    if (!e) {
        [self raise:XPNameError node:node format:@"cannot execute `for` loop on non-collection types", collObj];
        return;
    }
    
    while ([e hasMore]) {
        
        // set val
        NSMutableDictionary *vars = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *valName = valNode.name;
        
        if (keyNode) {
            NSString *keyName = keyNode.name;

            NSArray *pair = e.values[e.current];
            TDAssert(2 == [pair count]);
            XPObject *keyObj = pair[0];
            XPObject *valObj = pair[1];
            vars[keyName] = keyObj;
            vars[valName] = valObj;
        } else {
            XPObject *valObj = e.values[e.current];
            vars[valName] = valObj;
        }
        
        @try {
            [self block:block withVars:vars];
        } @catch (XPBreakException *ex) {
            break;
        } @catch (XPContinueException *ex) {
            // continue on
        }
        ++e.current;
    }
}


- (void)breakNode:(XPNode *)node {
    TDAssert(_breakException);
    @throw _breakException;
}


- (void)continueNode:(XPNode *)node {
    TDAssert(_continueException);
    @throw _continueException;
}


#pragma mark -
#pragma mark Try

- (void)try:(XPNode *)tryNode {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, tryNode);
    
    TDAssert(tryNode.children > 0);
    XPNode *catchNode = nil;
    XPNode *finallyNode = nil;
    
    if (tryNode.childCount > 1) {
        XPNode *kid1 = [tryNode childAtIndex:1];
        TDAssert(kid1.childCount > 0);
        
        if ([kid1.name isEqualToString:@"catch"]) {
            catchNode = kid1;
        } else {
            finallyNode = kid1;
        }
        
        if (tryNode.childCount > 2) {
            finallyNode = [tryNode childAtIndex:2];
        }
    }

    TDAssert(!catchNode || [catchNode.name isEqualToString:@"catch"]);
    TDAssert(!finallyNode || [finallyNode.name isEqualToString:@"finally"]);
    
    XPException *rethrow = nil;
    XPObject *thrownObj = nil;
    @try {
        XPNode *tryBlock = [tryNode childAtIndex:0];
        [self block:tryBlock withVars:nil];
    } @catch (XPUserThrownException *ex) {
        if (catchNode) {
            thrownObj = ex.thrownObject;
            TDAssert(thrownObj);
        } else {
            rethrow = [[ex retain] autorelease];
        }
    } @catch (XPException *ex) {
        // TODO. MUST UNWIND mem space stack ???
        
        if (catchNode) {
            NSDictionary *tab = @{
              [XPObject string:@"name"]  : [XPObject string:ex.name],
              [XPObject string:@"reason"]: [XPObject string:ex.reason],
              [XPObject string:@"line"]  : [XPObject number:ex.lineNumber],
            };
            thrownObj = [XPObject dictionary:tab];
        } else {
            rethrow = [[ex retain] autorelease];
        }
    } @finally {
        @try {
            if (catchNode && thrownObj) {
                XPNode *idNode = [catchNode childAtIndex:0];
                NSString *name = idNode.name;
                XPNode *catchBlock = [catchNode childAtIndex:1];
                [self block:catchBlock withVars:@{name: thrownObj}];
            }
        } @finally {
            if (finallyNode) {
                XPNode *finallyBlock = [finallyNode childAtIndex:0];
                [self block:finallyBlock withVars:nil];
            }
            
            if (rethrow) {
                TDAssert(!catchNode);
                @throw rethrow;
            }
        }
    }
}


- (void)throw:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPObject *thrownObj = [self walk:expr];

    XPUserThrownException *ex = [[[XPUserThrownException alloc] initWithThrownObject:thrownObj] autorelease];
    node = node.lineNumberNode;
    ex.lineNumber = node.token.lineNumber;
    ex.range = NSMakeRange(node.token.offset, [node.name length]);
    [ex raise];
}


#pragma mark -
#pragma mark If

- (id)ifBlock:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    BOOL b = [[self walk:expr] boolValue];
    if (b) {
        XPNode *block = [node childAtIndex:1];
        [self block:block];
        return [XPObject trueObject];
    }
    
    NSUInteger childCount = [node childCount];
    for (NSUInteger i = 2; i < childCount; ++i) {
        XPNode *test = [node childAtIndex:i];
        b = [[self walk:test] boolValue];
        if (b) break;
    }
    
    return [XPObject falseObject];
}


- (void)elseBlock:(XPNode *)node {
    XPNode *block = [node childAtIndex:0];
    [self block:block];
}


#pragma mark -
#pragma mark Functions

- (id)call:(XPNode *)node {
    XPFunctionSymbol *funcSym = nil;

    // EVAL TARGET / FUNC SYM
    {
        XPNode *targetNode = [node childAtIndex:0];
        XPObject *target = [self walk:targetNode];
        
        if ([target isFunctionObject]) {
            funcSym = target.value;
            TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
        } else {
            [self raise:XPTypeError node:node format:@"attempting to call a non-Subroutine object"];
            return nil;
        }
    }

    NSString *name = funcSym.name;
    XPFunctionSpace *funcSpace = [[[XPFunctionSpace alloc] initWithSymbol:funcSym] autorelease];
    TDAssert(NSNotFound != node.lineNumberNode.token.lineNumber);
    funcSpace.lineNumber = node.lineNumberNode.token.lineNumber;
    funcSpace.wantsPause = self.wantsPauseOnCall;

    // APPLY DEFAULT PARAMS
    {
        [self evalDefaultParams:funcSym];
        
        for (NSString *paramName in funcSym.defaultParamObjects) {
            XPObject *valObj = funcSym.defaultParamObjects[paramName];
            [funcSpace setObject:valObj forName:paramName];
        }
    }
    
    // EVAL ARGS
    NSUInteger argCount = [node childCount]-OFFSET;                         TDAssert(NSNotFound != argCount);
    {
        NSUInteger paramCount = [funcSym.params count];                     TDAssert(NSNotFound != paramCount);
        NSUInteger defaultParamCount = [funcSym.defaultParamObjects count]; TDAssert(NSNotFound != defaultParamCount);
        
        // check for too many args
        if (argCount > paramCount) {
            [self raise:XPTypeError node:node format:@"sub `%@` called with too many arguments.\n\t%ld given, no more than %ld expected", name, argCount, paramCount];
            return nil;
        }
        
        // check for too few args
        if (argCount + defaultParamCount < paramCount) {
            [self raise:XPTypeError node:node format:@"sub `%@` called with too few arguments.\n\t%ld given, at least %ld expected", name, argCount, paramCount-defaultParamCount];
            return nil;
        }
        
        NSArray *argExprs = [node.children subarrayWithRange:NSMakeRange(OFFSET, argCount)];
        
        TDAssert([funcSym.orderedParams count] >= [argExprs count]);
        
        NSUInteger i = 0;
        for (XPNode *argExpr in argExprs) {
            XPSymbol *param = funcSym.orderedParams[i++];
            XPObject *valObj = [self walk:argExpr];
            [funcSpace setObject:valObj forName:param.name];
        }
    }

    // CALL
    XPObject *result = nil;
    {
        TDAssert(self.callStack);
        [self.callStack addObject:funcSpace];
        
        // user-defined function
        if (funcSym.blockNode) {
            TDAssert(!funcSym.nativeBody);

            // PUSH MEMORY SPACE
            XPMemorySpace *savedCurrentSpace = self.currentSpace;
            TDAssert(savedCurrentSpace);
            TDAssert(NSNotFound != node.lineNumberNode.token.lineNumber);
            savedCurrentSpace.lineNumber = node.lineNumberNode.token.lineNumber;
            
            self.currentSpace = funcSpace;
            XPMemorySpace *savedClosureSpace = self.closureSpace;
            self.closureSpace = funcSym.closureSpace;

            @try {
                [self funcBlock:funcSym.blockNode];
            } @catch (XPReturnExpception *ex) {
                result = ex.value;
            }
            
            // POP MEMORY SPACE
            self.closureSpace = savedClosureSpace;
            self.currentSpace = savedCurrentSpace;
        }
        
        // native function
        else {
            TDAssert(funcSym.nativeBody);
            TDAssert(funcSpace);
            funcSym.nativeBody.dynamicSpace = self.currentSpace;
            @try {
                result = [funcSym.nativeBody callWithWalker:self functionSpace:funcSpace argc:argCount];
            } @catch (XPException *ex) {
                // just catch & rethrow to add lineNum and range
                [self raise:ex.name node:node format:ex.reason];
            } @finally {
                funcSym.nativeBody.dynamicSpace = nil;
            }
        }
        
        [self.callStack removeLastObject];
    }
    
    if (self.wantsPauseOnReturn) {
        self.currentSpace.wantsPause = YES;
    }
    
    if (!result) {
        result = [XPObject nullObject];
    }
    return result;
}


- (void)returnStat:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPObject *valObj = [[[self walk:expr] copy] autorelease];
    TDAssert(_returnException);
    _returnException.value = valObj;
    @throw _returnException;
}


#pragma mark -
#pragma mark Unary Expr

- (id)not:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPObject *obj = [self walk:expr];
    BOOL b = [obj boolValue];
    XPObject *res = [XPObject boolean:!b];
    return res;
}


- (id)neg:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPObject *obj = [self walk:expr];
    double n = [obj doubleValue];
    XPObject *res = [XPObject number:-n];
    return res;
}


#pragma mark -
#pragma mark Binary Expr

- (id)and:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] boolValue];
    BOOL rhs = [[self walk:[node childAtIndex:1]] boolValue];
    
    BOOL res = lhs && rhs;
    return [XPObject boolean:res];
}


- (id)or:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] boolValue];
    BOOL rhs = [[self walk:[node childAtIndex:1]] boolValue];
    
    BOOL res = lhs || rhs;
    return [XPObject boolean:res];
}


- (id)bitNot:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    
    NSInteger res = lrint(lhs);
    res = ~res;
    return [XPObject number:res];
}


- (id)bitAnd:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) & lrint(rhs);
    return [XPObject number:res];
}


- (id)bitOr:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) | lrint(rhs);
    return [XPObject number:res];
}


- (id)bitXor:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) ^ lrint(rhs);
    return [XPObject number:res];
}


- (id)shiftLeft:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) << lrint(rhs);
    return [XPObject number:res];
}


- (id)shiftRight:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) >> lrint(rhs);
    return [XPObject number:res];
}


- (id)rel:(XPNode *)node op:(NSInteger)op {
    XPObject *lhsObj = [self walk:[node childAtIndex:0]];
    XPObject *rhsObj = [self walk:[node childAtIndex:1]];
    
    BOOL res = [lhsObj compareToObject:rhsObj usingOperator:op];
    return [XPObject boolean:res];
}

    
- (id)eq:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_EQ]; }
- (id)ne:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_NE]; }
- (id)is:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_IS]; }


- (id)membership:(XPNode *)node {
    XPObject *obj = [self walk:[node childAtIndex:0]];
    XPObject *dict = [self walk:[node childAtIndex:1]];
    
    BOOL res = NO;
    
    if (dict.isDictionaryObject) {
        res = nil != [dict.value objectForKey:obj];
    } else {
        [self raise:XPTypeError node:node format:@"right-hand-side of `in` membership test must be a Dictionary object"];
    }
    
    return [XPObject boolean:res];
}
    

- (id)lt:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_LT]; }
- (id)le:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_LE]; }
- (id)gt:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_GT]; }
- (id)ge:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_GE]; }


- (id)math:(XPNode *)node op:(NSInteger)op {
    // (+ `2` `1`)
    XPObject *lhsObj = [self walk:[node childAtIndex:0]];
    XPObject *rhsObj = [self walk:[node childAtIndex:1]];
    
    return [self math:node lhs:lhsObj rhs:rhsObj op:op];
}


- (id)math:(XPNode *)node lhs:(XPObject *)lhsObj rhs:(XPObject *)rhsObj op:(NSInteger)op {
    double lhs = [lhsObj doubleValue];
    double rhs = [rhsObj doubleValue];

    double res = 0.0;
    switch (op) {
        case XP_TOKEN_KIND_PLUS:
            res = lhs + rhs;
            break;
        case XP_TOKEN_KIND_MINUS:
            res = lhs - rhs;
            break;
        case XP_TOKEN_KIND_TIMES:
            res = lhs * rhs;
            break;
        case XP_TOKEN_KIND_DIV: {
            if (0.0 == rhs) {
                [self raise:XPZeroDivisionError node:node format:@"cannot divide by 0.0"];
                return nil;
            }
            res = lhs / rhs;
        } break;
        case XP_TOKEN_KIND_MOD:
            res = lrint(lhs) % lrint(rhs);
            break;
        default:
            TDAssert(0);
            break;
    }

    return [XPObject number:res];
}


- (id)plus:(XPNode *)node {
    XPObject *lhsObj = [self walk:[node childAtIndex:0]];
    XPObject *rhsObj = [self walk:[node childAtIndex:1]];

    if (lhsObj.isStringObject) {
        return [self concat:node lhs:lhsObj rhs:rhsObj];
    } else {
        return [self math:node lhs:lhsObj rhs:rhsObj op:XP_TOKEN_KIND_PLUS];
    }
}


- (id)mod:(XPNode *)node {
    XPObject *lhsObj = [self walk:[node childAtIndex:0]];
    XPObject *rhsObj = [self walk:[node childAtIndex:1]];
    
    if ([lhsObj isStringObject]) {
        return [self format:node lhs:lhsObj rhs:rhsObj];
    } else {
        return [self math:node lhs:lhsObj rhs:rhsObj op:XP_TOKEN_KIND_MOD];
    }
}


- (id)minus:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_MINUS]; }
- (id)times:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_TIMES]; }
- (id)div:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_DIV]; }


- (id)concat:(XPNode *)node lhs:(XPObject *)lhsObj rhs:(XPObject *)rhsObj {
    NSString *lhs = [lhsObj stringValue];
    NSString *rhs = [rhsObj stringValue];
    NSString *res = [NSString stringWithFormat:@"%@%@", lhs, rhs];
    return [XPObject string:res];
}


- (id)format:(XPNode *)node lhs:(XPObject *)lhsObj rhs:(XPObject *)rhsObj {
    NSString *lhs = [lhsObj stringValue];
    
    NSArray *args = nil;
    if ([rhsObj isArrayObject]) {
        args = [[rhsObj.value copy] autorelease];
    } else {
        args = @[rhsObj];
    }

    const NSRegularExpression *sRegex = nil;
    if (!sRegex) {
        NSError *err = nil;
        sRegex = [[NSRegularExpression regularExpressionWithPattern:@"(?<!%)%(?:[sdi]|(?:\\d+)?(?:\\.\\d+)?f)" options:0 error:&err] retain];
        TDAssert(!err);
        TDAssert(sRegex);
    }
    
    NSArray *pats = [sRegex matchesInString:lhs options:0 range:NSMakeRange(0, [lhs length])];
    
    NSUInteger argCount = [args count];
    NSUInteger patCount = [pats count];
    
    if (argCount > patCount) {
        [self raise:XPTypeError node:node format:@"too many arguments for format string"];
        return nil;
    } else if (argCount < patCount) {
        [self raise:XPTypeError node:node format:@"not enough arguments for format string"];
        return nil;
    }
    
    NSMutableString *res = [NSMutableString stringWithString:lhs];
    
    NSUInteger i = argCount-1;
    for (XPObject *arg in [args reverseObjectEnumerator]) {
        NSTextCheckingResult *pat = [pats objectAtIndex:i--];
        TDAssert(pat.range.length > 1);
        unichar c = [lhs characterAtIndex:NSMaxRange(pat.range)-1];
        switch (c) {
            case 's': {
                [res replaceCharactersInRange:pat.range withString:[[arg asStringObject] stringValue]];
            } break;
            case 'i':
            case 'd': {
                NSString *rep = [NSString stringWithFormat:@"%ld", lround([[arg asNumberObject] doubleValue])];
                [res replaceCharactersInRange:pat.range withString:rep];
            } break;
            case 'f': {
                NSString *fmt = [lhs substringWithRange:pat.range];
                NSString *rep = [NSString stringWithFormat:fmt, [[arg asNumberObject] doubleValue]];
                [res replaceCharactersInRange:pat.range withString:rep];
            } break;
            default: {
                [self raise:XPTypeError node:node format:@"unknown format pattern : %%%C", c];
                return nil;
            } break;
        }
    }
    
    return [XPObject string:res];
}


#pragma mark -
#pragma mark Literals

- (id)null:(XPNode *)node {
    return [XPObject nullObject];
}


- (id)nan:(XPNode *)node {
    return [XPObject nanObject];
}


- (id)trueNode:(XPNode *)node {
    return [XPObject trueObject];
}


- (id)falseNode:(XPNode *)node {
    return [XPObject falseObject];
}


- (id)number:(XPNode *)node {
    XPObject *obj = [XPObject number:node.token.doubleValue];
    return obj;
}


- (id)string:(XPNode *)node {
    XPObject *obj = [XPObject string:node.name];
    return obj;
}


- (id)array:(XPNode *)node {
    // ([ a b)
    NSMutableArray *val = [NSMutableArray arrayWithCapacity:[node childCount]];
    
    for (XPNode *child in node.children) {
        XPObject *obj = [self walk:child];
        [val addObject:obj];
    }
    
    XPObject *obj = [XPObject array:val];
    return obj;
}


- (id)dictionary:(XPNode *)node {
    // (DICT (: b 2) (: a 1))
    NSMutableDictionary *val = [NSMutableDictionary dictionaryWithCapacity:[node childCount]];
    
    for (XPNode *pairNode in node.children) {
        TDAssert(2 == [pairNode childCount]);
        XPObject *keyObj = [self walk:[pairNode childAtIndex:0]];
        XPObject *valObj = [self walk:[pairNode childAtIndex:1]];
        [val setObject:valObj forKey:keyObj];
    }
    
    XPObject *obj = [XPObject dictionary:val];
    return obj;
}


- (id)function:(XPNode *)node {
    // (<ANON> <XPFunctionSymbol 0x100322580 <ANON>> (BLOCK (return 1)))
    XPFunctionSymbol *funcSym = [node childAtIndex:0];
    funcSym.closureSpace = self.currentSpace;
    XPObject *obj = [XPObject function:funcSym];
    return obj;
}

@end
