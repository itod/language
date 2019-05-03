//
//  FNSqrt.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNSqrt.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNSqrt

+ (NSString *)name {
    return @"sqrt";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"n"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"n",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *obj = [space objectForName:@"n"];
    TDAssert(obj);
    
    [self checkNumberArgument:obj];

    double res = sqrt(obj.doubleValue);
    return [XPObject number:res];
}

@end
