//
//  FNLowerCase.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNLowerCase.h"
#import "XPObject.h"
#import "XPStringClass.h"
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNLowerCase

+ (NSString *)name {
    return @"lowercase";
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


- (XPObject *)callInSpace:(XPMemorySpace *)space {
    TDAssert(space);
    
    XPObject *str = [space objectForName:@"str"];
    TDAssert(str);
    
    NSString *v = [str.value lowercaseString];
    
    XPObject *res = [XPStringClass instanceWithValue:v];
    return res;
}

@end
