//
//  FNHasKey.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNHasKey.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNHasKey

+ (NSString *)name {
    return @"hasKey";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"dictionary"];
    XPSymbol *key = [XPSymbol symbolWithName:@"key"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, key, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"dictionary",
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
    } else {
        [self raise:XPTypeError format:@"first argument to `hasKey()` must be a Dictionary object"];
    }
    
    return [XPObject boolean:res];
}

@end
