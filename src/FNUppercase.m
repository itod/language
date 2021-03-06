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
#import "XPStringClass.h"

@implementation FNUppercase

+ (NSString *)name {
    return @"uppercase";
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
    
    NSString *v = [[str stringValue] uppercaseString];
    
    XPObject *res = [XPObject string:v];
    return res;
}

@end
