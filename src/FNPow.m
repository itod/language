//
//  FNPow.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNPow.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNPow

+ (NSString *)name {
    return @"pow";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"n"];
    XPSymbol *e = [XPSymbol symbolWithName:@"e"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, e, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"n",
                      e, @"e",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *obj = [space objectForName:@"n"]; TDAssert(obj);
    XPObject *e = [space objectForName:@"e"]; TDAssert(e);
    
    [self checkNumberArgument:obj];
    [self checkNumberArgument:e];

    double res = pow(obj.doubleValue, e.doubleValue);
    return [XPObject number:res];
}

@end
