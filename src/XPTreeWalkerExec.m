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

#import "XPValue.h"
#import "XPBooleanValue.h"
#import "XPNumericValue.h"
#import "XPFunctionValue.h"
#import "XPNode.h"
#import "XPExpression.h"

#import "XPVariableSymbol.h"
#import "XPFunctionSymbol.h"

#import "XPParser.h"

#define OFFSET 1

@interface XPFlowException : NSException
@property (nonatomic, retain) XPValue *value;
@end

@implementation XPFlowException

- (void)dealloc {
    self.value = nil;
    [super dealloc];
}

@end

@interface XPTreeWalker ()
- (id)_loadVariableReference:(XPNode *)node;
@end

@interface XPTreeWalkerExec ()
@property (nonatomic, retain) XPFlowException *sharedReturnValue;
@end

@implementation XPTreeWalkerExec

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sharedReturnValue = [[[XPFlowException alloc] initWithName:@"Flow" reason:nil userInfo:nil] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.sharedReturnValue = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Variables

- (void)varDecl:(XPNode *)node {
    NSString *name = [[[node childAtIndex:0] token] stringValue];
    XPExpression *expr = [node childAtIndex:1];
    XPValue *val = [self walk:expr];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}


- (void)assign:(XPNode *)node {
    XPNode *idNode = [node childAtIndex:0];
    NSString *name = idNode.token.stringValue;
    
    
    
    
    
    // TODO: WHY NOT USING _loadVarRef:
    if (![self.currentSpace objectForName:name]) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    XPExpression *expr = [node childAtIndex:1];
    XPValue *val = [expr evaluateInContext:self];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}


- (void)assignIndex:(XPNode *)node {
    XPNode *qidNode = [node childAtIndex:0];
    NSString *name = qidNode.token.stringValue;
    

    
    
    
    // TODO: WHY NOT USING _loadVarRef:
    XPValue *arrayVal = [self.currentSpace objectForName:name];
    
    if (!arrayVal) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    if (![arrayVal isArrayValue]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed assignment on non-array object `%@`", name];
        return;
    }

    XPExpression *idxExpr = [node childAtIndex:1];
    NSInteger idx = [idxExpr evaluateAsNumberInContext:self];
    
    if (idx < 0 || idx >= [arrayVal childCount]) {
        [self raise:XPExceptionArrayIndexOutOfBounds node:node format:@"array index out of bounds: `%ld`", idx];
        return;
    }

    XPValue *val = [[node childAtIndex:2] evaluateInContext:self];

    [arrayVal replaceChild:val atIndex:idx];
}


- (void)assignAppend:(XPNode *)node {
    XPNode *qidNode = [node childAtIndex:0];
    NSString *name = qidNode.token.stringValue;
    
    
    
    
    
    // TODO: WHY NOT USING _loadVarRef:
    XPValue *arrayVal = [self.currentSpace objectForName:name];
    
    if (!arrayVal) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    if (![arrayVal isArrayValue]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed assignment on non-array object `%@`", name];
        return;
    }
    
    XPValue *val = [[node childAtIndex:1] evaluateInContext:self];
    
    [arrayVal addChild:val];

}


#pragma mark -
#pragma mark While

- (void)whileBlock:(XPNode *)node {
    XPExpression *expr = [node childAtIndex:0];
    XPNode *block = [node childAtIndex:1];
    
    BOOL b = [[self walk:expr] evaluateAsBooleanInContext:self];
    while (b) {
        [self block:block];
        b = [[self walk:expr] evaluateAsBooleanInContext:self];
    }
}


#pragma mark -
#pragma mark If

- (id)ifBlock:(XPNode *)node {
    XPExpression *expr = [node childAtIndex:0];
    BOOL b = [expr evaluateAsBooleanInContext:self];
    if (b) {
        XPNode *block = [node childAtIndex:1];
        [self block:block];
        return @YES;
    }
    
    NSUInteger childCount = [node childCount];
    for (NSUInteger i = 2; i < childCount; ++i) {
        XPNode *test = [node childAtIndex:i];
        b = [[self walk:test] boolValue];
        if (b) break;
    }
    
    return @NO;
}


- (void)elseBlock:(XPNode *)node {
    XPNode *block = [node childAtIndex:0];
    [self block:block];
}


#pragma mark -
#pragma mark Functions

- (id)funcCall:(XPNode *)node {
    XPFunctionSymbol *funcSym = nil;
    NSString *name = nil;

    // FIND FUNC SYM
    {
        XPNode *nameNode = [node childAtIndex:0];
        name = nameNode.token.stringValue;
        
        // maybe this was a call on a func literal
        XPValue *var = [self _loadVariableReference:nameNode];
        
        if (var) {
            if ([var isFunctionValue]) {
                funcSym = (id)[var childAtIndex:0];
            } else {
                [self raise:XPExceptionTypeMismatch node:node format:@"illegal call to `%@()`, `%@` is not a function", name, name];
                return nil;
            }
        }
        
        // or a statically-declared func
        if (!funcSym) {
            funcSym = (id)[node.scope resolveSymbolNamed:name];
        }
        
        if (!funcSym) {
            [self raise:XPExceptionUndeclaredSymbol node:node format:@"call to known function named: `%@`", name];
            return nil;
        }
        
        TDAssert([funcSym isKindOfClass:[XPFunctionSymbol class]]);
    }

    // PUSH MEMORY SPACE
    XPFunctionSpace *funcSpace = [XPFunctionSpace spaceWithSymbol:funcSym];
    XPMemorySpace *saveSpace = self.currentSpace;
    TDAssert(saveSpace);

    // APPLY DEFAULT PARAMS
    for (NSString *name in funcSym.defaultParamValues) {
        XPExpression *expr = funcSym.defaultParamValues[name];
        XPValue *val = [expr evaluateInContext:self];
        [funcSpace setObject:val forName:name];
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
        for (XPExpression *argExpr in argExprs) {
            XPSymbol *param = funcSym.orderedParams[i];
            XPValue *argValue = [argExpr evaluateInContext:self];
            [funcSpace setObject:argValue forName:param.name];
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
            [self walk:funcSym.blockNode];
        } @catch (XPFlowException *ex) {
            result = ex.value;
        }
        [self.stack removeLastObject];
    }
    
    // POP MEMORY SPACE
    self.currentSpace = saveSpace;
    return result;
}


- (void)returnStat:(XPNode *)node {
    XPExpression *expr = [node childAtIndex:0];
    XPValue *val = [self walk:expr];
    TDAssert(_sharedReturnValue);
    _sharedReturnValue.value = val;
    @throw _sharedReturnValue;
}


#pragma mark -
#pragma mark Binary Expr

- (id)or:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] evaluateAsBooleanInContext:self];
    BOOL rhs = [[self walk:[node childAtIndex:1]] evaluateAsBooleanInContext:self];
    
    BOOL res = lhs || rhs;
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (id)and:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] evaluateAsBooleanInContext:self];
    BOOL rhs = [[self walk:[node childAtIndex:1]] evaluateAsBooleanInContext:self];
    
    BOOL res = lhs && rhs;
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (id)rel:(XPNode *)node op:(NSInteger)op {
    XPValue *lhs = [[self walk:[node childAtIndex:0]] evaluateInContext:self];
    XPValue *rhs = [[self walk:[node childAtIndex:1]] evaluateInContext:self];
    
    BOOL res = [lhs compareToValue:rhs usingOperator:op];
    return [XPBooleanValue booleanValueWithBoolean:res];
}

- (id)eq:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_EQ]; }
- (id)ne:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_NE]; }

- (id)lt:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_LT]; }
- (id)le:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_LE]; }
- (id)gt:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_GT]; }
- (id)ge:(XPNode *)node { return [self rel:node op:XP_TOKEN_KIND_GE]; }


- (id)math:(XPNode *)node op:(NSInteger)op {
    double lhs = [[self walk:[node childAtIndex:0]] evaluateAsNumberInContext:self];
    double rhs = [[self walk:[node childAtIndex:1]] evaluateAsNumberInContext:self];
    
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

    return [XPNumericValue numericValueWithNumber:res];
}

- (id)plus:(XPNode *)node   { return [self math:node op:XP_TOKEN_KIND_PLUS]; }
- (id)minus:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_MINUS]; }
- (id)times:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_TIMES]; }
- (id)div:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_DIV]; }
- (id)mod:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_MOD]; }
@end
