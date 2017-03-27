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

@implementation FNPow

+ (NSString *)name {
    return @"pow";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *n = [XPSymbol symbolWithName:@"n"];
    XPSymbol *e = [XPSymbol symbolWithName:@"e"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:n, e, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      n, @"n",
                      e, @"e",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *n = [space objectForName:@"n"]; TDAssert(n);
    XPObject *e = [space objectForName:@"e"]; TDAssert(e);
    
    double res = pow(n.doubleValue, e.doubleValue);
    return [XPObject number:res];
}

@end
