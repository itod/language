//
//  FNPosition.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNPosition.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNPosition

+ (NSString *)name {
    return @"position";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *col = [XPSymbol symbolWithName:@"collection"];
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    XPSymbol *identity = [XPSymbol symbolWithName:@"compareIdentity"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:col, obj, identity, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      col, @"collection",
                      obj, @"object",
                      identity, @"compareIdentity",
                      nil];
    
    [funcSym setDefaultObject:[XPObject falseObject] forParamNamed:@"compareIdentity"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *col = [space objectForName:@"collection"];
    TDAssert(col);
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    BOOL identity = [[space objectForName:@"compareIdentity"] boolValue];
    
    NSUInteger idx = NSNotFound;
    
    if ([col isDictionaryObject]) {
        if (identity) {
            idx = [[col.value allKeys] indexOfObjectIdenticalTo:obj];
        } else {
            idx = [col.value objectForKey:obj] ? 0 : NSNotFound;
        }
    } else if ([col isArrayObject]) {
        if (identity) {
            idx = [col.value indexOfObjectIdenticalTo:obj];
        } else {
            idx = [col.value indexOfObject:obj];
        }
    } else {
        NSString *v = [col stringValue];
        if (identity) {
            if (obj.isStringObject) {
                idx = [v rangeOfString:[obj stringValue]].location;
            } else {
                idx = NSNotFound;
            }
        } else {
            idx = [v rangeOfString:[obj stringValue]].location;
        }
    }
    
    double res = NSNotFound == idx ? 0 : idx+1;
    
    return [XPObject number:res];
}

@end
