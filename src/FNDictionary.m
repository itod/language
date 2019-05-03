//
//  FNDictionary.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNDictionary.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPDictionaryClass.h"

@implementation FNDictionary

+ (NSString *)name {
    return @"Dictionary";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPDictionaryClass classInstance];
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"dictionary"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"dictionary",
                      nil];
    
    [funcSym setDefaultObject:[XPObject dictionary:@{}] forParamNamed:@"dictionary"]; // immutable here is fine. discarded below

    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *arg = [space objectForName:@"dictionary"];
    TDAssert([arg isKindOfClass:[XPObject class]]);

    if (!arg.isDictionaryObject) {
        [self raise:XPTypeError format:@"optional argument to Dictionary() must be an Dictionary object"];
        return nil;
    }
    
    NSDictionary *v = [arg value];
    TDAssert([v isKindOfClass:[NSDictionary class]]);
    return [XPObject dictionary:v]; // mutable copies
}

@end
