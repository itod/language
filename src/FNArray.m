//
//  FNArray.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNArray.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNArray

+ (NSString *)name {
    return @"Array";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"array"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"array",
                      nil];
    
    [funcSym setDefaultObject:[XPObject array:@[]] forParamNamed:@"array"]; // immutable here is fine. discarded below

    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *arg = [space objectForName:@"array"];
    TDAssert([arg isKindOfClass:[XPObject class]]);

    if (!arg.isArrayObject) {
        [self raise:XPTypeError format:@"optional argument to Array() must be an Array object"];
        return nil;
    }
    
    NSArray *v = [arg value];
    TDAssert([v isKindOfClass:[NSArray class]]);
    return [XPObject array:v]; // mutable copies
}

@end
