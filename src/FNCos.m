//
//  FNCos.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNCos.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNCos

+ (NSString *)name {
    return @"cos";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *n = [XPSymbol symbolWithName:@"n"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:n, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      n, @"n",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    TDAssert(space);
    
    XPObject *n = [space objectForName:@"n"];
    TDAssert(n);
    
    double res = cos(n.doubleValue);
    return [XPObject number:res];
}

@end
