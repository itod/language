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
    
    [funcSym setDefaultObject:[XPObject nullObject] forParamNamed:@"function"];

    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *array = [space objectForName:@"array"];
    TDAssert(array);
    XPObject *func = [space objectForName:@"function"];
    TDAssert(func);
    
    if (![array isArrayObject]) {
        [self raise:XPTypeError format:@"first argument to `sort()` must be an Array object"];
        return nil;
    }
    
    XPFunctionSymbol *funcSym = nil;

    if (![func isFunctionObject]) {
        if (func == [XPObject nullObject]) {
            funcSym = nil;
        } else {
            [self raise:XPTypeError format:@"second argument to `sort()` must be a Subroutine object"];
            return nil;
        }
    } else {
        funcSym = func.value;
    }

    XPMemorySpace *savedSpace = walker.currentSpace;

    NSMutableArray *vec = array.value;
    [vec sortUsingComparator:^NSComparisonResult (id obj0, id obj1) {
        TDAssert([obj0 isKindOfClass:[XPObject class]]);
        TDAssert([obj1 isKindOfClass:[XPObject class]]);

        NSComparisonResult res = NSOrderedSame;
        
        if (funcSym) {
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
            XPObject *retObj = nil;
            {
                TDAssert(walker.callStack);
                [walker.callStack addObject:funcSpace];
                
                TDAssert(funcSym.blockNode);
                @try {
                    [walker funcBlock:funcSym.blockNode];
                } @catch (XPReturnExpception *ex) {
                    retObj = ex.value;
                }
                
                [walker.callStack removeLastObject];
            }
            
            // CONVERT TO NUMBER
            NSInteger retVal = lround([[retObj asNumberObject] doubleValue]);
            
            if (retVal < 0) {
                res = NSOrderedDescending;
            } else if (retVal > 0) {
                res = NSOrderedAscending;
            } else {
                res = NSOrderedSame;
            }
        } else {
            res = [[obj0 value] compare:[obj1 value]];
        }
        
        return res;
    }];
    
    // POP MEMORY SPACE
    walker.currentSpace = savedSpace;

    return nil;
}

@end
