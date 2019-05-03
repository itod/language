//
//  FNBoolean.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNBoolean.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPBooleanClass.h"

@implementation FNBoolean

+ (NSString *)name {
    return @"Boolean";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPBooleanClass classInstance];
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"object",
                      nil];
    
    [funcSym setDefaultObject:[XPObject boolean:NO] forParamNamed:@"object"];

    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    return [[space objectForName:@"object"] asBooleanObject];
}

@end
