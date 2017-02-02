//
//  XPTreeWalkerEval.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerEval.h"
#import "XPException.h"

#import "XPMemorySpace.h"
#import "XPFunctionSpace.h"

#import "XPValue.h"
#import "XPNode.h"
#import "XPExpression.h"

#import "XPVariableSymbol.h"
#import "XPFunctionSymbol.h"

@interface XPFlowException : NSException
@property (nonatomic, retain) XPValue *value;
@end

@implementation XPFlowException

- (void)dealloc {
    self.value = nil;
    [super dealloc];
}

@end

@interface XPTreeWalkerEval ()
@property (nonatomic, retain) XPFlowException *sharedReturnValue;
@end

@implementation XPTreeWalkerEval

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
#pragma mark Walker

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
    
#define OFFSET 1
    
    NSUInteger argCount = [node childCount]-OFFSET;
    TDAssert(NSNotFound != argCount);
    
    NSUInteger paramCount = [funcSym.params count];
    TDAssert(NSNotFound != paramCount);

    // check for argument compatibility.
    if (argCount > paramCount) {
        [self raise:XPExceptionTooManyArguments node:node format:@"sub `%@` called with too many arguments. %@ given, %@ expected", name, argCount, paramCount];
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

@end
