//
//  FNGlobals.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNGlobals.h"
#import <Language/XPObject.h>
#import "XPDictionaryClass.h"
#import "XPStringClass.h"
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


- (XPObject *)callWithWalker:(XPTreeWalker *)walker argc:(NSUInteger)argc {
    TDAssert([walker.lexicalStack count]);
    XPMemorySpace *space = walker.globals;
    TDAssert([space isKindOfClass:[XPMemorySpace class]]);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[space.members count]];

    for (NSString *key in space.members) {
        TDAssert([key isKindOfClass:[NSString class]]);
        XPObject *valObj = space.members[key];
        TDAssert([valObj isKindOfClass:[XPObject class]]);
        XPObject *keyObj = [XPObject string:key];
        dict[keyObj] = valObj;
    }

    XPObject *res = [XPDictionaryClass instanceWithValue:dict];
    return res;
}

@end
