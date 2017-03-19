//
//  FNPosition.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNPosition.h"
#import <Language/XPObject.h>
#import "XPNumberClass.h"
#import "XPFunctionSymbol.h"
#import <Language/XPTreeWalker.h>
#import "XPMemorySpace.h"

@implementation FNPosition

+ (NSString *)name {
    return @"position";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *seq = [XPSymbol symbolWithName:@"sequence"];
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    XPSymbol *identity = [XPSymbol symbolWithName:@"compareIdentity"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:seq, obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      seq, @"sequence",
                      obj, @"object",
                      identity, @"compareIdentity",
                      nil];
    
    [funcSym setDefaultObject:[XPObject falseObject] forParamNamed:@"compareIdentity"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    XPObject *seq = [space objectForName:@"sequence"];
    TDAssert(seq);
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    BOOL identity = [[space objectForName:@"compareIdentity"] boolValue];
    
    NSUInteger idx = NSNotFound;
    
    if ([seq isArrayObject]) {
        if (identity) {
            idx = [seq.value indexOfObjectIdenticalTo:obj];
        } else {
            idx = [seq.value indexOfObject:obj];
        }
    } else {
        NSString *v = [seq stringValue];
        idx = [v rangeOfString:[obj stringValue]].location;
    }
    
    double res = NSNotFound == idx ? 0 : idx+1;
    
    return [XPNumberClass instanceWithValue:@(res)];
}

@end
