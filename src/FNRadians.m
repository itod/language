//
//  FNRadians.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNRadians.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNRadians

+ (NSString *)name {
    return @"radians";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *degrees = [XPSymbol symbolWithName:@"degrees"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:degrees, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      degrees, @"degrees",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *degrees = [space objectForName:@"degrees"];
    TDAssert(degrees);

    [self checkNumberArgument:degrees];

    double res = (M_PI * (degrees.doubleValue) / 180.0);
    return [XPObject number:res];
}

@end
