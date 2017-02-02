//
//  XPTreeWalkerEval.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerEval.h"
#import "XPMemorySpace.h"
#import "XPNode.h"
#import "XPExpression.h"
#import "XPValue.h"
#import "XPException.h"
#import "XPFunctionSymbol.h"
#import "XPFunctionSpace.h"

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
        self.sharedReturnValue = [[[XPFlowException alloc] init] autorelease];
    }
    return self;
}


- (void)dealloc {
    self.sharedReturnValue = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark Tree Walker

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


- (void)funcDecl:(XPNode *)node {
    //    for (XPNode *stat in node.children) {
    //        [self walk:stat];
    //    }
}


- (id)funcCall:(XPNode *)node {
    NSString *name = [[[node childAtIndex:0] token] stringValue];
    XPFunctionSymbol *funcSym = (id)[node.scope resolveSymbolNamed:name];
    if (!funcSym) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"Call to known function named: %@", name];
        return nil;
    }
    
    XPFunctionSpace *funcSpace = [XPFunctionSpace spaceWithSymbol:funcSym];
    TDAssert(self.currentSpace)
    XPMemorySpace *saveSpace = self.currentSpace;
    
    id result = nil;
    
    
    self.currentSpace = saveSpace;
    return result;
}


- (void)returnStat:(XPNode *)node {
    XPExpression *expr = [node childAtIndex:0];
    XPValue *val = [expr evaluateInContext:nil];
    _sharedReturnValue.value = val;
    @throw _sharedReturnValue;
}

@end
