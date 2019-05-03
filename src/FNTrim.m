//
//  FNTrim.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNTrim.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPStringClass.h"

@implementation FNTrim

+ (NSString *)name {
    return @"trim";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPStringClass classInstance];
    
    XPSymbol *str = [XPSymbol symbolWithName:@"string"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:str, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      str, @"string",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *str = [space objectForName:@"string"];
    TDAssert(str);
    
    NSMutableString *v = [[str.value mutableCopy] autorelease];
    CFStringTrimWhitespace((CFMutableStringRef)v);
    
    XPObject *res = [XPObject string:v];
    return res;
}

@end
