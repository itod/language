//
//  FNSort.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNSort.h"
#import <Language/XPObject.h>
#import "XPFunctionSymbol.h"
#import "XPFunctionSpace.h"
#import "XPFlowExceptions.h"
#import <Language/XPException.h>
#import <Language/XPTreeWalker.h>

@implementation FNSort

+ (NSString *)name {
    return @"sort";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
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
        [self raise:XPTypeError format:@"first argument to `sort()` must be an Array object"];
        return nil;
    }
    
    if (![func isFunctionObject]) {
        [self raise:XPTypeError format:@"second argument to `sort()` must be a Subroutine object"];
        return nil;
    }
    
    XPMemorySpace *savedSpace = walker.currentSpace;

    NSMutableArray *vec = array.value;
    [vec sortedArrayUsingComparator:^NSComparisonResult (id obj0, id obj1) {
        TDAssert([obj0 isKindOfClass:[XPObject class]]);
        TDAssert([obj1 isKindOfClass:[XPObject class]]);

        // PUSH MEMORY SPACE
        XPFunctionSpace *funcSpace = [[[XPFunctionSpace alloc] initWithSymbol:funcSym] autorelease];
        
        walker.currentSpace = funcSpace;
        
        // EVAL ARGS
        {
            XPSymbol *param0 = funcSym.orderedParams[0];
            [funcSpace setObject:obj0 forName:param0.name];

            XPSymbol *param1 = funcSym.orderedParams[1];
            [funcSpace setObject:obj1 forName:param1.name];
        }
        
        // CALL
        XPObject *retVal = nil;
        {
            TDAssert(walker.callStack);
            [walker.callStack addObject:funcSpace];
            
            TDAssert(funcSym.blockNode);
            @try {
                [walker funcBlock:funcSym.blockNode];
            } @catch (XPReturnExpception *ex) {
                retVal = ex.value;
            }
            
            [walker.callStack removeLastObject];
        }
        
        // CONVERT TO NUMBER
        retVal = [retVal asNumberObject];
        
        NSComparisonResult res;
        if (retVal < 0) {
            res = NSOrderedDescending;
        } else if (retVal > 0) {
            res = NSOrderedAscending;
        } else {
            res = NSOrderedSame;
        }
        
        return res;
    }];
    
    // POP MEMORY SPACE
    walker.currentSpace = savedSpace;

    return nil;
}

@end
