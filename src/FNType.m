//
//  FNType.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNType.h"
#import "XPObject.h"
#import "XPStringClass.h"
#import "XPFunctionSymbol.h"
#import "XPTreeWalker.h"
#import "XPMemorySpace.h"

@implementation FNType

+ (NSString *)name {
    return @"type";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"object",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);

    NSString *name = [obj.objectClass name];
    XPObject *res = [XPStringClass instanceWithValue:name];
    return res;
}

@end
