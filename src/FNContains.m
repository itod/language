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
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    XPSymbol *key = [XPSymbol symbolWithName:@"key"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, key, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"object",
                      key, @"key",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    XPObject *key = [space objectForName:@"key"];
    TDAssert(key);
    
    NSUInteger res = 0;
    
    if (obj.isDictionaryObject) {
        res = nil != [obj.value objectForKey:key];
    } else {
        NSString *str = [obj stringValue];
        NSRange range = [str rangeOfString:[key stringValue]];
        if (NSNotFound != range.location) {
            res = range.location + 1; // 1-indexed
        }
    }
    
    return [XPObject number:res];
}

@end
