//
//  FNFilter.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNFilter.h"
#import <Language/XPObject.h>
#import "XPFunctionSymbol.h"
#import "XPFunctionSpace.h"
#import "XPFlowExceptions.h"
#import <Language/XPException.h>
#import <Language/XPTreeWalker.h>

@implementation FNFilter

+ (NSString *)name {
    return @"filter";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *coll = [XPSymbol symbolWithName:@"collection"];
    XPSymbol *func = [XPSymbol symbolWithName:@"function"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:coll, func, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      coll, @"collection",
                      func, @"function",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker argc:(NSUInteger)argc {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    XPObject *coll = [space objectForName:@"collection"];
    TDAssert(coll);
    XPObject *func = [space objectForName:@"function"];
    TDAssert(func);
    
    XPFunctionSymbol *funcSym = func.value;
    
    if (![coll isArrayObject]) {
        [XPException raise:XPExceptionTypeMismatch format:@"`map()` subroutine called on non-array object"];
        return nil;
    }
    
    NSArray *old = coll.value;
    NSMutableArray *new = [NSMutableArray arrayWithCapacity:[old count]];
    
    for (XPObject *oldItem in old) {
        TDAssert([oldItem isKindOfClass:[XPObject class]]);
        
        // PUSH MEMORY SPACE
        XPFunctionSpace *funcSpace = [XPFunctionSpace functionSpaceWithSymbol:funcSym];
        walker.currentSpace = funcSpace;
        
        // EVAL ARGS
        {
            XPSymbol *param = funcSym.orderedParams[0];
            [funcSpace setObject:oldItem forName:param.name];
        }
        
        // CALL
        XPObject *yn = nil;
        {
            TDAssert(walker.callStack);
            [walker.callStack addObject:funcSpace];
            
            TDAssert(funcSym.blockNode);
            @try {
                [walker funcBlock:funcSym.blockNode];
            } @catch (XPReturnExpception *ex) {
                yn = ex.value;
            }
            
            [walker.callStack removeLastObject];
        }
        
        if ([yn boolValue]) {
            [new addObject:oldItem];
        }
        
        // POP MEMORY SPACE
        walker.currentSpace = space;
    }
    
    return [XPObject array:new];
}

@end
