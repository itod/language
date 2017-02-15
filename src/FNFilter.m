//
//  FNFilter.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNFilter.h"
#import "XPObject.h"
#import "XPFunctionClass.h"
#import "XPArrayClass.h"
#import "XPFunctionSymbol.h"
#import "XPFunctionSpace.h"
#import "XPException.h"
#import "XPReturnException.h"
#import "XPTreeWalker.h"

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


- (XPObject *)callInSpace:(XPMemorySpace *)space walker:(XPTreeWalker *)walker {
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
            TDAssert(walker.stack);
            [walker.stack addObject:funcSpace];
            
            TDAssert(funcSym.blockNode);
            @try {
                [walker funcBlock:funcSym.blockNode];
            } @catch (XPReturnExpception *ex) {
                yn = ex.value;
            }
            
            [walker.stack removeLastObject];
        }
        
        if ([yn boolValue]) {
            [new addObject:oldItem];
        }
        
        // POP MEMORY SPACE
        walker.currentSpace = space;
    }
    
    return [XPArrayClass instanceWithValue:new];
}

@end
