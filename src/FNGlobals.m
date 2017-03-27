//
//  FNGlobals.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNGlobals.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNGlobals

+ (NSString *)name {
    return @"globals";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPMemorySpace *globals = walker.globals;
    TDAssert([globals isKindOfClass:[XPMemorySpace class]]);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[globals.members count]];

    for (NSString *key in globals.members) {
        TDAssert([key isKindOfClass:[NSString class]]);
        XPObject *valObj = globals.members[key];
        TDAssert([valObj isKindOfClass:[XPObject class]]);
        XPObject *keyObj = [XPObject string:key];
        dict[keyObj] = valObj;
    }

    XPObject *res = [XPObject dictionary:dict];
    return res;
}

@end
