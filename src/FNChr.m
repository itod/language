//
//  FNChr.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNChr.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPStringClass.h"

@implementation FNChr

+ (NSString *)name {
    return @"chr";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPStringClass classInstance];
    
    XPSymbol *num = [XPSymbol symbolWithName:@"number"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:num, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      num, @"number",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *num = [space objectForName:@"number"];
    TDAssert(num);
    
    if (!num.isNumericObject) {
        [self raise:XPTypeError format:@"chr() expected Number, but '%@' found", [num.objectClass name]];
        return nil;
    }
    
    unichar c = num.integerValue;
    NSString *str = [NSString stringWithFormat:@"%C", c];
    XPObject *res = [XPObject string:str];
    return res;
}

@end
