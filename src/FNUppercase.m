//
//  FNUppercase.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNUppercase.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNUppercase

+ (NSString *)name {
    return @"uppercase";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *str = [XPSymbol symbolWithName:@"str"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:str, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      str, @"str",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *str = [space objectForName:@"str"];
    TDAssert(str);
    
    NSString *v = [str.value uppercaseString];
    
    XPObject *res = [XPObject string:v];
    return res;
}

@end
