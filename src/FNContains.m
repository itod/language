//
//  FNContains.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNContains.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNContains

+ (NSString *)name {
    return @"contains";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
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
    } else {
        [self raise:XPTypeError format:@"first argument to `contains()` must be a Dictionary object"];
    }
    
    return [XPObject boolean:res];
}

@end
