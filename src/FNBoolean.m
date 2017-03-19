//
//  FNBoolean.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNBoolean.h"
#import <Language/XPObject.h>
#import "XPFunctionSymbol.h"
#import <Language/XPTreeWalker.h>
#import "XPMemorySpace.h"

@implementation FNBoolean

+ (NSString *)name {
    return @"Boolean";
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
    return [[walker.currentSpace objectForName:@"object"] asBooleanObject];
}

@end
