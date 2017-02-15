//
//  FNMap.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNMap.h"
#import "XPObject.h"
#import "XPFunctionClass.h"
#import "XPArrayClass.h"
#import "XPFunctionSymbol.h"
#import "XPFunctionSpace.h"
#import "XPException.h"

@implementation FNMap

+ (NSString *)name {
    return @"map";
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


- (XPObject *)callInSpace:(XPMemorySpace *)space {
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
        
        // EVAL ARGS
        {
            XPSymbol *param = funcSym.orderedParams[0];
            [funcSpace setObject:oldItem forName:param.name];
        }
        
        // CALL
        XPObject *newItem = nil;
//        {
//            TDAssert(self.stack);
//            [self.stack addObject:funcSpace];
//            
//            TDAssert(funcSym.blockNode);
//            @try {
//                [self funcBlock:funcSym.blockNode];
//            } @catch (XPReturnExpception *ex) {
//                newItem = ex.value;
//            }
//            
//            [self.stack removeLastObject];
//        }
        
        [new addObject:newItem];
    }
    
    return [XPArrayClass instanceWithValue:new];
}

@end
