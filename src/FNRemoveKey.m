//
//  FNRemoveKey.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNRemoveKey.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPBooleanClass.h"

@implementation FNRemoveKey

+ (NSString *)name {
    return @"removeKey";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPBooleanClass classInstance];
    
    XPSymbol *col = [XPSymbol symbolWithName:@"dictionary"];
    XPSymbol *key = [XPSymbol symbolWithName:@"key"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:col, key, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      col, @"dictionary",
                      key, @"key",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *obj = [space objectForName:@"dictionary"];
    TDAssert(obj);
    XPObject *key = [space objectForName:@"key"];
    TDAssert(key);
    
    BOOL res = NO;
    
    if (obj.isDictionaryObject) {
        res = nil != [obj.value objectForKey:key];
        if (res) {
            [obj.value removeObjectForKey:key];
        }
    } else {
        [self raise:XPTypeError format:@"first argument to `removeKey()` must be a Dictionary object"];
    }
    
    return [XPObject boolean:res];
}

@end
