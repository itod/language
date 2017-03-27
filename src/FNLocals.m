//
//  FNLocals.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNLocals.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNLocals

+ (NSString *)name {
    return @"locals";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    space = self.dynamicSpace;
    TDAssert(space);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[space.members count]]; // -allMembers ???

    for (NSString *key in space.members) {
        TDAssert([key isKindOfClass:[NSString class]]);
        XPObject *valObj = space.members[key];
        TDAssert([valObj isKindOfClass:[XPObject class]]);
        XPObject *keyObj = [XPObject string:key];
        dict[keyObj] = valObj;
    }

    XPObject *res = [XPObject dictionary:dict];
    return res;
}

@end
