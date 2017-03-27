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
    
    XPSymbol *recurse = [XPSymbol symbolWithName:@"recurse"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:recurse, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      recurse, @"recurse",
                      nil];
    
    [funcSym setDefaultObject:[XPObject falseObject] forParamNamed:@"recurse"];

    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    BOOL recurse = [[space objectForName:@"recurse"] boolValue];

    space = self.dynamicSpace;
    TDAssert(space);
    
    NSDictionary *mems = recurse ? space.allMembers : space.members;
    NSMutableDictionary *res = [NSMutableDictionary dictionaryWithCapacity:[mems count]]; // -allMembers ???

    for (NSString *key in mems) {
        TDAssert([key isKindOfClass:[NSString class]]);
        XPObject *valObj = mems[key];
        TDAssert([valObj isKindOfClass:[XPObject class]]);
        XPObject *keyObj = [XPObject string:key];
        res[keyObj] = valObj;
    }

    return [XPObject dictionary:res];
}

@end
