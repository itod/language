//
//  XPTreeWalkerExec.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerExec.h"
#import "XPException.h"

#import "XPMemorySpace.h"
#import "XPFunctionSpace.h"

#import "XPNode.h"

#import "XPVariableSymbol.h"
#import "XPFunctionSymbol.h"
#import "XPFunctionBody.h"

#import "XPParser.h"

#import "XPObject.h"
#import "XPBooleanClass.h"
#import "XPNumberClass.h"
#import "XPStringClass.h"
#import "XPArrayClass.h"
#import "XPDictionaryClass.h"
#import "XPFunctionClass.h"

#import "XPSymbol.h"

#import "XPEnumeration.h"
#import "XPReturnException.h"

#define OFFSET 1

@interface XPTreeWalker ()
- (id)_loadVariableReference:(XPNode *)node;
@end

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
        [self raise:XPExceptionReservedWord node:node format:@"cannot define variable with reserved name `%@`", name];
        return;
    }
    
    XPNode *expr = [node childAtIndex:1];
    XPObject *valObj = [self walk:expr];
    TDAssert([valObj isKindOfClass:[XPObject class]]);
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:valObj forName:name];
}


- (void)funcDecl:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (sub make (BLOCK (return [)))

    XPNode *nameNode = [node childAtIndex:0];
    NSString *name = nameNode.token.stringValue;

    if ([[XPSymbol reservedWords] containsObject:name]) {
        [self raise:XPExceptionReservedWord node:node format:@"cannot define subroutine with reserved name `%@`", name];
        return;
    }
    
    XPFunctionSymbol *funcSym = nil;
    {
        // maybe this was a call on a func literal
        XPObject *var = [self _loadVariableReference:nameNode];
        TDAssert([var isKindOfClass:[XPObject class]]);
        funcSym = var.value;
        TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
    }

    [self evalDefaultParams:funcSym];

//    NSString *name = [[[node childAtIndex:0] token] stringValue];
//    TDAssert(node.scope);
//        
//    XPSymbol *funcSym = [node.scope resolveSymbolNamed:name];
//    TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
//    
//    XPObject *obj = [XPFunctionClass instanceWithValue:funcSym];
//    
//    TDAssert(self.currentSpace);
//    [self.currentSpace setObject:obj forName:name];
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
    NSString *name = idNode.token.stringValue;
    
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    if (!space) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
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

    XPObject *valObj = [XPNumberClass instanceWithValue:@(res)];
    [space setObject:valObj forName:name];
}


- (void)plusEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_PLUSEQ]; }
- (void)minusEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_MINUSEQ]; }
- (void)timesEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_TIMESEQ]; }
- (void)divEq:(XPNode *)node { [self assignEq:node op:XP_TOKEN_KIND_DIVEQ]; }


- (void)assign:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    XPNode *idNode = [node childAtIndex:0];
    NSString *name = idNode.token.stringValue;
    
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    if (!space) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
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
    
    return [XPNumberClass instanceWithValue:@(res)];
}


- (void)saveSubscript:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (SET_IDX foo `0` `c`)
    XPNode *idNode = [node childAtIndex:0];
    
    XPObject *collObj = [self loadVariableReference:idNode];
    
    if (!collObj) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", idNode.token.stringValue];
        return;
    }
    
    if ([collObj isStringObject] || [collObj isArrayObject]) {
        XPNode *idxNode = [node childAtIndex:1];
        NSInteger idx = [[self walk:idxNode] doubleValue];

        // check array bounds
        {
            NSInteger checkIdx = labs(idx);
            NSInteger len = [[collObj callInstanceMethodNamed:@"count"] integerValue];
            
            if (checkIdx < 1 || checkIdx > len) {
                [self raise:XPExceptionArrayIndexOutOfBounds node:node format:@"array index out of bounds: `%ld`", idx];
                return;
            }
        }
        
        XPNode *valNode = [node childAtIndex:2];
        XPObject *valObj = [self walk:valNode];
        
        [collObj callInstanceMethodNamed:@"set" withArgs:@[@(idx), valObj]];
    }
    
    else if ([collObj isDictionaryObject]) {
        XPNode *keyNode = [node childAtIndex:1];
        XPObject *keyObj = [self walk:keyNode];
        
        XPNode *valNode = [node childAtIndex:2];
        XPObject *valObj = [self walk:valNode];
        
        [collObj callInstanceMethodNamed:@"set" withArgs:@[keyObj, valObj]];
    }
    
    else {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed assignment on non-array object `%@`", idNode.token.stringValue];
        return;
    }
}


- (void)append:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (APPEND foo `c`)
    XPNode *idNode = [node childAtIndex:0];
    
    XPObject *seqObj = [self loadVariableReference:idNode];
    
    if (!seqObj) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", idNode.token.stringValue];
        return;
    }
    
    if (![seqObj isStringObject] && ![seqObj isArrayObject]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed assignment on non-sequence object `%@`", idNode.token.stringValue];
        return;
    }
    
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


- (id)loadSubscript:(XPNode *)node {
    // (GET_IDX (LOAD foo) `0`)
    XPNode *refNode = [node childAtIndex:0];
    XPNode *startNode = [node childAtIndex:1];
    XPNode *stopNode = nil;
    XPNode *stepNode = nil;
    
    if ([node childCount] > 2) {
        stopNode = [node childAtIndex:2];
        
        if ([node childCount] > 3) {
            stepNode = [node childAtIndex:3];
        }
    }
    
    XPObject *obj = [self load:refNode];

    XPObject *res = nil;

    if ([obj isStringObject] || [obj isArrayObject]) {
        NSInteger start = [[self walk:startNode] doubleValue];
        
        if (stopNode) {
            NSInteger stop = [[self walk:stopNode] doubleValue];
            NSInteger step = 1;
            if (stepNode) {
                step = [[self walk:stepNode] doubleValue];
            }
            res = [obj callInstanceMethodNamed:@"slice" withArgs:@[@(start), @(stop), @(step)]];
        } else {
            res = [obj callInstanceMethodNamed:@"get" withArg:@(start)];
        }
    }
    
    else if ([obj isDictionaryObject]) {
        if (stopNode) {
            [self raise:XPExceptionTypeMismatch node:node format:@"attempting sliced subscript access on dictionary object `%@`", refNode.token.stringValue];
            return nil;
        }
        TDAssert(!stepNode);
        XPObject *keyObj = [self walk:startNode];
        
        res = [obj callInstanceMethodNamed:@"get" withArg:keyObj];
    }
    
    else {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting subscript access on non-collection object `%@`", refNode.token.stringValue];
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
        [self raise:XPExceptionTypeMismatch node:node format:@"cannot execute `for` loop on non-collection types", collObj];
        return;
    }
    
    while ([e hasMore]) {
        
        // set val
        NSMutableDictionary *vars = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *valName = valNode.token.stringValue;
        
        if (keyNode) {
            NSString *keyName = keyNode.token.stringValue;

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
    NSString *name = nil;

    // FIND FUNC SYM
    {
        XPNode *nameNode = [node childAtIndex:0];
        name = nameNode.token.stringValue;
        
        // maybe this was a call on a func literal
        XPObject *var = [self _loadVariableReference:nameNode];
        
        if (var) {
            TDAssert([var isKindOfClass:[XPObject class]]);
            if ([var isFunctionObject]) {
                funcSym = var.value;
                TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
            } else {
                [self raise:XPExceptionTypeMismatch node:node format:@"illegal call to `%@()`, `%@` is not a subroutine", name, name];
                return nil;
            }
        }
        
        // NOT NEEDED CUZ ALL FUNCS ARE DATA VALUES (for fwd indirect reference)
//        // or a statically-declared func
//        if (!funcSym) {
//            funcSym = (id)[node.scope resolveSymbolNamed:name];
//        }
        
        if (!funcSym) {
            [self raise:XPExceptionUndeclaredSymbol node:node format:@"call to known subroutine named: `%@`", name];
            return nil;
        }
        
        TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
    }

    XPFunctionSpace *funcSpace = [XPFunctionSpace functionSpaceWithSymbol:funcSym];
    funcSpace.wantsPause = self.wantsPauseOnCall;

    // APPLY DEFAULT PARAMS
    {
        [self evalDefaultParams:funcSym];
        
        for (NSString *name in funcSym.defaultParamObjects) {
            XPObject *valObj = funcSym.defaultParamObjects[name];
            [funcSpace setObject:valObj forName:name];
        }
    }
    
    // EVAL ARGS
    {
        NSUInteger argCount = [node childCount]-OFFSET;                     TDAssert(NSNotFound != argCount);
        NSUInteger paramCount = [funcSym.params count];                     TDAssert(NSNotFound != paramCount);
        NSUInteger defaultParamCount = [funcSym.defaultParamObjects count]; TDAssert(NSNotFound != defaultParamCount);
        
        // check for too many args
        if (argCount > paramCount) {
            [self raise:XPExceptionTooManyArguments node:node format:@"sub `%@` called with too many arguments. %ld given, no more than %ld expected", name, argCount, paramCount];
            return nil;
        }
        
        // check for too few args
        if (argCount + defaultParamCount < paramCount) {
            [self raise:XPExceptionTooFewArguments node:node format:@"sub `%@` called with too few arguments. %@ld given, at least %ld expected", name, argCount, paramCount-defaultParamCount];
            return nil;
        }
        
        NSArray *argExprs = [node.children subarrayWithRange:NSMakeRange(OFFSET, argCount)];
        
        NSUInteger i = 0;
        for (XPNode *argExpr in argExprs) {
            XPSymbol *param = funcSym.orderedParams[i];
            XPObject *valObj = [self walk:argExpr];
            [funcSpace setObject:valObj forName:param.name];
            ++i;
        }
    }

    // PUSH MEMORY SPACE
    XPMemorySpace *savedCurrentSpace = self.currentSpace;
    TDAssert(savedCurrentSpace);
    savedCurrentSpace.lineNumber = node.lineNumber;
    [self.lexicalStack addObject:savedCurrentSpace];
    
    self.currentSpace = funcSpace;
    XPMemorySpace *savedClosureSpace = self.closureSpace;
    self.closureSpace = funcSym.closureSpace;

    // CALL
    XPObject *result = nil;
    {
        TDAssert(self.callStack);
        [self.callStack addObject:funcSpace];
        
        // user-defined function
        if (funcSym.blockNode) {
            TDAssert(!funcSym.nativeBody);
            @try {
                [self funcBlock:funcSym.blockNode];
            } @catch (XPReturnExpception *ex) {
                result = ex.value;
            }
        }
        
        // native function
        else {
            TDAssert(funcSym.nativeBody);
            result = [funcSym.nativeBody callWithWalker:self];
        }
        
        [self.callStack removeLastObject];
    }

    // POP MEMORY SPACE
    self.closureSpace = savedClosureSpace;
    self.currentSpace = savedCurrentSpace;
    [self.lexicalStack removeLastObject];
    
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
    XPObject *res = [XPNumberClass instanceWithValue:@(-n)];
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
    return [XPNumberClass instanceWithValue:@(res)];
}


- (id)bitAnd:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) & lrint(rhs);
    return [XPNumberClass instanceWithValue:@(res)];
}


- (id)bitOr:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) | lrint(rhs);
    return [XPNumberClass instanceWithValue:@(res)];
}


- (id)bitXor:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) ^ lrint(rhs);
    return [XPNumberClass instanceWithValue:@(res)];
}


- (id)shiftLeft:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) << lrint(rhs);
    return [XPNumberClass instanceWithValue:@(res)];
}


- (id)shiftRight:(XPNode *)node {
    double lhs = [[self walk:[node childAtIndex:0]] doubleValue];
    double rhs = [[self walk:[node childAtIndex:1]] doubleValue];
    
    double res = lrint(lhs) >> lrint(rhs);
    return [XPNumberClass instanceWithValue:@(res)];
}


- (id)rel:(XPNode *)node op:(NSInteger)op {
    XPObject *lhs = [self walk:[node childAtIndex:0]];
    XPObject *rhs = [self walk:[node childAtIndex:1]];
    
    BOOL res = [lhs compareToObject:rhs usingOperator:op];
    return [XPObject boolean:res];
}

- (id)eq:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_EQ]; }
- (id)ne:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_NE]; }
- (id)is:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_IS]; }

- (id)lt:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_LT]; }
- (id)le:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_LE]; }
- (id)gt:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_GT]; }
- (id)ge:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_GE]; }


- (id)math:(XPNode *)node op:(NSInteger)op {
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

    return [XPNumberClass instanceWithValue:@(res)];
}

- (id)plus:(XPNode *)node   { return [self math:node op:XP_TOKEN_KIND_PLUS]; }
- (id)minus:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_MINUS]; }
- (id)times:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_TIMES]; }
- (id)div:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_DIV]; }
- (id)mod:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_MOD]; }


- (id)concat:(XPNode *)node {
    NSString *lhs = [[self walk:[node childAtIndex:0]] stringValue];
    NSString *rhs = [[self walk:[node childAtIndex:1]] stringValue];
    NSString *res = [NSString stringWithFormat:@"%@%@", lhs, rhs];
    return [XPStringClass instanceWithValue:res];
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
    XPObject *obj = [XPNumberClass instanceWithValue:@(node.token.doubleValue)];
    return obj;
}


- (id)string:(XPNode *)node {
    XPObject *obj = [XPStringClass instanceWithValue:node.token.stringValue];
    return obj;
}


- (id)array:(XPNode *)node {
    // ([ a b)
    NSMutableArray *val = [NSMutableArray arrayWithCapacity:[node childCount]];
    
    for (XPNode *child in node.children) {
        XPObject *obj = [self walk:child];
        [val addObject:obj];
    }
    
    XPObject *obj = [XPArrayClass instanceWithValue:val];
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
    
    XPObject *obj = [XPDictionaryClass instanceWithValue:val];
    return obj;
}


- (id)function:(XPNode *)node {
    // (<ANON> <XPFunctionSymbol 0x100322580 <ANON>> (BLOCK (return 1)))
    XPFunctionSymbol *funcSym = [node childAtIndex:0];
    funcSym.closureSpace = self.currentSpace;
    XPObject *obj = [XPFunctionClass instanceWithValue:funcSym];
    return obj;
}

@end
