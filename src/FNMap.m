//
//  FNMap.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNMap.h"
#import <Language/XPObject.h>
#import "XPFunctionSymbol.h"
#import "XPFunctionSpace.h"
#import "XPFlowExceptions.h"
#import <Language/XPException.h>
#import <Language/XPTreeWalker.h>
#import "XPArrayClass.h"

@implementation FNMap

+ (NSString *)name {
    return @"map";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPArrayClass classInstance];
    
    XPSymbol *array = [XPSymbol symbolWithName:@"array"];
    XPSymbol *func = [XPSymbol symbolWithName:@"function"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:array, func, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      array, @"array",
                      func, @"function",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *array = [space objectForName:@"array"];
    TDAssert(array);
    XPObject *func = [space objectForName:@"function"];
    TDAssert(func);
    
    XPFunctionSymbol *funcSym = func.value;
    
    if (![array isArrayObject]) {
        [self raise:XPTypeError format:@"first argument to `map()` must be an Array object"];
        return nil;
    }
    
    if (![func isFunctionObject]) {
        [self raise:XPTypeError format:@"second argument to `map()` must be a Subroutine object"];
        return nil;
    }
    
    NSArray *old = array.value;
    NSMutableArray *new = [NSMutableArray arrayWithCapacity:[old count]];
    
    for (XPObject *oldItem in old) {
        TDAssert([oldItem isKindOfClass:[XPObject class]]);
        
        XPMemorySpace *savedSpace = walker.currentSpace;

        // PUSH MEMORY SPACE
        XPFunctionSpace *funcSpace = [[[XPFunctionSpace alloc] initWithSymbol:funcSym] autorelease];
        
        walker.currentSpace = funcSpace;

        // EVAL ARGS
        {
            XPSymbol *param = funcSym.orderedParams[0];
            [funcSpace setObject:oldItem forName:param.name];
        }
        
        // CALL
        XPObject *newItem = nil;
        {
            TDAssert(walker.callStack);
            [walker.callStack addObject:funcSpace];
            
            TDAssert(funcSym.blockNode);
            @try {
                [walker funcBlock:funcSym.blockNode];
            } @catch (XPReturnExpception *ex) {
                newItem = ex.value;
            }
            
            [walker.callStack removeLastObject];
        }
        
        [new addObject:newItem];
        
        // POP MEMORY SPACE
        walker.currentSpace = savedSpace;
    }
    
    return [XPObject array:new];
}

@end
