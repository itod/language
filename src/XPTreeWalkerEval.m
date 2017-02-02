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
@property (nonatomic, retain) NSMutableArray<XPFunctionSpace *> *stack;
@end

@implementation XPTreeWalkerEval

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sharedReturnValue = [[[XPFlowException alloc] initWithName:@"Flow" reason:nil userInfo:nil] autorelease];
        self.stack = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.sharedReturnValue = nil;
    self.stack = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark XPScope

- (NSString *)scopeName {  TDAssert(0); return nil; }
- (id <XPScope>)enclosingScope { TDAssert(0); return nil; }
- (void)defineSymbol:(XPSymbol *)sym {TDAssert(0); }
- (XPSymbol *)resolveSymbolNamed:(NSString *)name { TDAssert(0); return nil; }


#pragma mark -
#pragma mark XPContext

- (id)loadVariableReference:(XPNode *)node {
    NSString *name = node.token.stringValue;
    XPMemorySpace *space = [self spaceWithSymbolNamed:name];
    id res = [space objectForName:name];
    if (!res) {
        [self raise:XPExceptionUndeclaredSymbol node:node format:@"Unknown var reference: `%@`", name];
    }
    return res;
}


- (XPMemorySpace *)spaceWithSymbolNamed:(NSString *)name {
    XPMemorySpace *space = nil;
    
    TDAssert(_stack);
    if ([_stack count] && [[_stack lastObject] objectForName:name]) {
        space = [_stack lastObject];
    }
    
    if (!space && [self.globals objectForName:name]) {
        space = self.globals;
    }
    
    return space;
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


- (void)funcDecl:(XPNode *)node {
    //    for (XPNode *stat in node.children) {
    //        [self walk:stat];
    //    }
}


//- (id)varRef:(XPNode *)node {
//    NSString *name = [[[node childAtIndex:0] token] stringValue];
//    
//    XPExpression *expr = [self.currentSpace objectForName:name];
//    XPValue *val = [expr evaluateInContext:nil];
//    return val;
//}
//
//
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
    
    id result = nil;
    TDAssert(_stack);
    [_stack addObject:funcSpace];

    TDAssert(funcSym.blockNode);
    @try {
        [self walk:funcSym.blockNode];
    } @catch (XPFlowException *ex) {
        result = ex.value;
    }
    [_stack removeLastObject];
    
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
