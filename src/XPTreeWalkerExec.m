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
#import "XPNode.h"
#import "XPExpression.h"

#import "XPVariableSymbol.h"
#import "XPFunctionSymbol.h"

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
    
    if (![self.currentSpace objectForName:name]) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"attempting to assign to undeclared symbol `%@`", name];
        return;
    }
    
    XPExpression *expr = [node childAtIndex:1];
    XPValue *val = [expr evaluateInContext:nil];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}


#pragma mark -
#pragma mark Functions

- (id)funcCall:(XPNode *)node {
    NSString *name = [[[node childAtIndex:0] token] stringValue];
    XPFunctionSymbol *funcSym = (id)[node.scope resolveSymbolNamed:name];
    if (!funcSym) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"Call to known function named: %@", name];
        return nil;
    }
    
    XPFunctionSpace *funcSpace = [XPFunctionSpace spaceWithSymbol:funcSym];
    XPMemorySpace *saveSpace = self.currentSpace;
    TDAssert(saveSpace);

    // apply default param values
    for (NSString *name in funcSym.defaultParamValues) {
        XPExpression *expr = funcSym.defaultParamValues[name];
        XPValue *val = [expr evaluateInContext:self];
        [funcSpace setObject:val forName:name];
    }
    
    NSUInteger argCount = [node childCount]-OFFSET;
    TDAssert(NSNotFound != argCount);
    NSUInteger paramCount = [funcSym.params count];
    TDAssert(NSNotFound != paramCount);
    NSUInteger defaultParamCount = [funcSym.defaultParamValues count];
    TDAssert(NSNotFound != defaultParamCount);
    
    // check for too many args
    if (argCount > paramCount) {
        [self raise:XPExceptionTooManyArguments node:node format:@"sub `%@` called with too many arguments. %ld given, no more than %ld expected", name, argCount, paramCount];
        return nil;
    }
    
    // check for too few args
    if (argCount + defaultParamCount < paramCount) {
        [self raise:XPExceptionTooManyArguments node:node format:@"sub `%@` called with too few arguments. %@ld given, at least %ld expected", name, argCount, paramCount-defaultParamCount];
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
    
    id result = nil;
    TDAssert(self.stack);
    [self.stack addObject:funcSpace];

    TDAssert(funcSym.blockNode);
    @try {
        [self walk:funcSym.blockNode];
    } @catch (XPFlowException *ex) {
        result = ex.value;
    }
    [self.stack removeLastObject];
    
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

@end
