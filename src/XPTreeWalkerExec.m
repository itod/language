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
#pragma mark DECL

- (void)varDecl:(XPNode *)node {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    NSString *name = [[[node childAtIndex:0] token] stringValue];
    XPNode *expr = [node childAtIndex:1];
    XPValue *val = [[[self walk:expr] copy] autorelease];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}


- (void)funcDecl:(XPNode *)node {
}


#pragma mark -
#pragma mark ASSIGN

- (void)assign:(XPNode *)node {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, node);
    XPNode *idNode = [node childAtIndex:0];
    NSString *name = idNode.token.stringValue;
    
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    if (!space) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    XPNode *expr = [node childAtIndex:1];
    XPValue *val = [[[self walk:expr] copy] autorelease];
    
    [space setObject:val forName:name];
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

    XPNode *idxExpr = [node childAtIndex:1];
    NSInteger idx = [[self walk:idxExpr] doubleValue];
    
    if (idx < 0 || idx >= [arrayVal childCount]) {
        [self raise:XPExceptionArrayIndexOutOfBounds node:node format:@"array index out of bounds: `%ld`", idx];
        return;
    }

    XPValue *val = [self walk:[node childAtIndex:2]];

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
    
    XPValue *val = [self walk:[node childAtIndex:1]];
    
    [arrayVal addChild:val];

}


#pragma mark -
#pragma mark LOAD


- (id)load:(XPNode *)node {
    XPNode *idNode = [node childAtIndex:0];
    XPValue *val = [self loadVariableReference:idNode];
    return val;
}


- (id)loadIndex:(XPNode *)node {
    XPValue *ref = [self load:[node childAtIndex:0]];
    
    if (![ref isArrayValue]) {
        [self raise:XPExceptionTypeMismatch node:node format:@"attempting indexed access on non-array object `%@`", ref.token.stringValue];
        return nil;
    }
    
    XPValue *idx = [self walk:[node childAtIndex:1]];
    NSUInteger i = [idx doubleValue];
    
    XPValue *res = [ref childAtIndex:i];
    return res;
}


#pragma mark -
#pragma mark While

- (void)whileBlock:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPNode *block = [node childAtIndex:1];
    
    BOOL b = [[self walk:expr] boolValue];
    while (b) {
        [self block:block];
        b = [[self walk:expr] boolValue];
    }
}


#pragma mark -
#pragma mark If

- (id)ifBlock:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    BOOL b = [[self walk:expr] boolValue];
    if (b) {
        XPNode *block = [node childAtIndex:1];
        [self block:block];
        return [XPBooleanValue booleanValueWithBoolean:YES];
    }
    
    NSUInteger childCount = [node childCount];
    for (NSUInteger i = 2; i < childCount; ++i) {
        XPNode *test = [node childAtIndex:i];
        b = [[self walk:test] boolValue];
        if (b) break;
    }
    
    return [XPBooleanValue booleanValueWithBoolean:NO];
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
    XPFunctionSpace *funcSpace = [XPFunctionSpace functionSpaceWithSymbol:funcSym];
    XPMemorySpace *saveSpace = self.currentSpace;
    TDAssert(saveSpace);
    self.currentSpace = funcSpace;

    // APPLY DEFAULT PARAMS
    for (NSString *name in funcSym.defaultParamValues) {
        XPNode *expr = funcSym.defaultParamValues[name];
        XPValue *val = [self walk:expr];
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
        for (XPNode *argExpr in argExprs) {
            XPSymbol *param = funcSym.orderedParams[i];
            XPValue *argValue = [self walk:argExpr];
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
            [self funcBlock:funcSym.blockNode];
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
    XPNode *expr = [node childAtIndex:0];
    XPValue *val = [self walk:expr];
    TDAssert(_sharedReturnValue);
    _sharedReturnValue.value = val;
    @throw _sharedReturnValue;
}


#pragma mark -
#pragma mark Unary Expr

- (id)not:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPValue *val = [self walk:expr];
    BOOL b = [val boolValue];
    XPValue *res = [XPBooleanValue booleanValueWithBoolean:!b];
    return res;
}


- (id)neg:(XPNode *)node {
    XPNode *expr = [node childAtIndex:0];
    XPValue *val = [self walk:expr];
    double n = [val doubleValue];
    XPValue *res = [XPNumericValue numericValueWithNumber:-n];
    return res;
}


#pragma mark -
#pragma mark Binary Expr

- (id)or:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] boolValue];
    BOOL rhs = [[self walk:[node childAtIndex:1]] boolValue];
    
    BOOL res = lhs || rhs;
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (id)and:(XPNode *)node {
    BOOL lhs = [[self walk:[node childAtIndex:0]] boolValue];
    BOOL rhs = [[self walk:[node childAtIndex:1]] boolValue];
    
    BOOL res = lhs && rhs;
    return [XPBooleanValue booleanValueWithBoolean:res];
}


- (id)rel:(XPNode *)node op:(NSInteger)op {
    XPValue *lhs = [self walk:[node childAtIndex:0]];
    XPValue *rhs = [self walk:[node childAtIndex:1]];
    
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

    return [XPNumericValue numericValueWithNumber:res];
}

- (id)plus:(XPNode *)node   { return [self math:node op:XP_TOKEN_KIND_PLUS]; }
- (id)minus:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_MINUS]; }
- (id)times:(XPNode *)node  { return [self math:node op:XP_TOKEN_KIND_TIMES]; }
- (id)div:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_DIV]; }
- (id)mod:(XPNode *)node    { return [self math:node op:XP_TOKEN_KIND_MOD]; }
@end
