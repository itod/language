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

#import "XPParser.h"

#import "XPObject.h"
#import "XPBooleanClass.h"
#import "XPNumberClass.h"
#import "XPStringClass.h"
#import "XPArrayClass.h"
#import "XPFunctionClass.h"

#define OFFSET 1

@interface XPReturnExpception : NSException
@property (nonatomic, retain) XPObject *value;
@end

@implementation XPReturnExpception

- (void)dealloc {
    self.value = nil;
    [super dealloc];
}

@end

@interface XPBreakException : NSException
@end

@implementation XPBreakException
@end

@interface XPContinueException : NSException
@end

@implementation XPContinueException
@end

@interface XPTreeWalker ()
- (id)_loadVariableReference:(XPNode *)node;
@end

@interface XPTreeWalkerExec ()
@property (nonatomic, retain) XPReturnExpception *returnException;
@property (nonatomic, retain) XPBreakException *breakException;
@property (nonatomic, retain) XPContinueException *continueException;
@end

@implementation XPTreeWalkerExec

- (instancetype)init {
    self = [super init];
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
    XPNode *expr = [node childAtIndex:1];
    XPObject *valObj = [self walk:expr];
    TDAssert([valObj isKindOfClass:[XPObject class]]);
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:valObj forName:name];
}


- (void)funcDecl:(XPNode *)node {
    // (sub make (BLOCK (return [)))
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    
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


#pragma mark -
#pragma mark ASSIGN

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


- (void)assignIndex:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (SET_IDX foo `0` `c`)
    XPNode *idNode = [node childAtIndex:0];
    
    XPObject *arrObj = [self loadVariableReference:idNode];
    
    if (!arrObj) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", idNode.token.stringValue];
        return;
    }
    
    if (![arrObj isArrayObject]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed assignment on non-array object `%@`", idNode.token.stringValue];
        return;
    }

    XPNode *idxNode = [node childAtIndex:1];
    NSInteger idx = [[self walk:idxNode] doubleValue];
    
    NSInteger len = [[arrObj callInstanceMethodNamed:@"length"] integerValue];
    
    if (idx < 0 || idx >= len) {
        [self raise:XPExceptionArrayIndexOutOfBounds node:node format:@"array index out of bounds: `%ld`", idx];
        return;
    }

    XPNode *valNode = [node childAtIndex:2];
    XPObject *valObj = [self walk:valNode];

    [arrObj callInstanceMethodNamed:@"set" args:@[@(idx), valObj]];
}


- (void)assignAppend:(XPNode *)node {
    //NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    // (APPEND foo `c`)
    XPNode *idNode = [node childAtIndex:0];
    
    XPObject *arrObj = [self loadVariableReference:idNode];
    
    if (!arrObj) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", idNode.token.stringValue];
        return;
    }
    
    if (![arrObj isArrayObject]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed assignment on non-array object `%@`", idNode.token.stringValue];
        return;
    }
    
    XPNode *valNode = [node childAtIndex:1];
    XPObject *valObj = [self walk:valNode];
    
    [arrObj callInstanceMethodNamed:@"append" withArg:valObj];
}


#pragma mark -
#pragma mark LOAD


- (id)load:(XPNode *)node {
    // (LOAD foo)
    XPNode *idNode = [node childAtIndex:0];
    XPObject *obj = [self loadVariableReference:idNode];
    return obj;
}


- (id)loadIndex:(XPNode *)node {
    // (GET_IDX (LOAD foo) `0`)
    XPNode *refNode = [node childAtIndex:0];
    XPNode *idxNode = [node childAtIndex:1];
    XPObject *obj = [self load:refNode];
    
    if (![obj isArrayObject]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed access on non-array object `%@`", refNode.token.stringValue];
        return nil;
    }
    
    NSUInteger i = [[self walk:idxNode] doubleValue];
    
    XPObject *res = [obj callInstanceMethodNamed:@"get" withArg:@(i)];
    return res;
}


#pragma mark -
#pragma mark While

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
        return [XPBooleanClass instanceWithValue:@YES];
    }
    
    NSUInteger childCount = [node childCount];
    for (NSUInteger i = 2; i < childCount; ++i) {
        XPNode *test = [node childAtIndex:i];
        b = [[self walk:test] boolValue];
        if (b) break;
    }
    
    return [XPBooleanClass instanceWithValue:@NO];
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
                [self raise:XPExceptionTypeMismatch node:node format:@"illegal call to `%@()`, `%@` is not a function", name, name];
                return nil;
            }
        }
        
        // NOT NEEDED CUZ ALL FUNCS ARE DATA VALUES (for fwd indirect reference)
//        // or a statically-declared func
//        if (!funcSym) {
//            funcSym = (id)[node.scope resolveSymbolNamed:name];
//        }
        
        if (!funcSym) {
            [self raise:XPExceptionUndeclaredSymbol node:node format:@"call to known function named: `%@`", name];
            return nil;
        }
        
        TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
    }

    // PUSH MEMORY SPACE
    XPFunctionSpace *funcSpace = [XPFunctionSpace functionSpaceWithSymbol:funcSym];
    XPMemorySpace *saveSpace = self.currentSpace;
    TDAssert(saveSpace);
    self.currentSpace = funcSpace;

    // APPLY DEFAULT PARAMS
    for (NSString *name in funcSym.defaultParamValues) {
        XPNode *expr = funcSym.defaultParamValues[name];
        XPObject *valObj = [self walk:expr];
        [funcSpace setObject:valObj forName:name];
    }
    
    // EVAL ARGS
    {
        NSUInteger argCount = [node childCount]-OFFSET;                     TDAssert(NSNotFound != argCount);
        NSUInteger paramCount = [funcSym.params count];                     TDAssert(NSNotFound != paramCount);
        NSUInteger defaultParamCount = [funcSym.defaultParamValues count];  TDAssert(NSNotFound != defaultParamCount);
        
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
    
    // CALL
    id result = nil;
    {
        TDAssert(self.stack);
        [self.stack addObject:funcSpace];
        
        TDAssert(funcSym.blockNode);
        @try {
            [self funcBlock:funcSym.blockNode];
        } @catch (XPReturnExpception *ex) {
            result = ex.value;
        }
        [self.stack removeLastObject];
    }
    
    // POP MEMORY SPACE
    self.currentSpace = saveSpace;
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
    XPObject *res = [XPBooleanClass instanceWithValue:@(!b)];
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

- (id)or:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] boolValue];
    BOOL rhs = [[self walk:[node childAtIndex:1]] boolValue];
    
    BOOL res = lhs || rhs;
    return [XPBooleanClass instanceWithValue:@(res)];
}


- (id)and:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] boolValue];
    BOOL rhs = [[self walk:[node childAtIndex:1]] boolValue];
    
    BOOL res = lhs && rhs;
    return [XPBooleanClass instanceWithValue:@(res)];
}


- (id)rel:(XPNode *)node op:(NSInteger)op {
    XPObject *lhs = [self walk:[node childAtIndex:0]];
    XPObject *rhs = [self walk:[node childAtIndex:1]];
    
    BOOL res = [lhs compareToObject:rhs usingOperator:op];
    return [XPBooleanClass instanceWithValue:@(res)];
}

- (id)eq:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_EQ]; }
- (id)ne:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_NE]; }

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

    return [XPBooleanClass instanceWithValue:@(res)];
}

- (id)plus:(XPNode *)node   { return [self math:node op:XP_TOKEN_KIND_PLUS]; }
- (id)minus:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_MINUS]; }
- (id)times:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_TIMES]; }
- (id)div:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_DIV]; }
- (id)mod:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_MOD]; }


#pragma mark -
#pragma mark Literals

- (id)boolean:(XPNode *)node {
    // false
    XPObject *obj = [XPBooleanClass instanceWithValue:([node.token.stringValue isEqualToString:@"true"]) ? @YES : @NO];
    return obj;
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


- (id)function:(XPNode *)node {
    // (<ANON> <XPFunctionSymbol 0x100322580 <ANON>> (BLOCK (return 1)))
    XPFunctionSymbol *funcSym = [node childAtIndex:0];
    XPObject *obj = [XPFunctionClass instanceWithValue:funcSym];
    return obj;
}



@end
