//
//  FNDegrees.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNDegrees.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNDegrees

+ (NSString *)name {
    return @"degrees";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *radians = [XPSymbol symbolWithName:@"radians"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:radians, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      radians, @"radians",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *radians = [space objectForName:@"radians"];
    TDAssert(radians);

    [self checkNumberArgument:radians];

    double res = ((radians.doubleValue) * 180.0 / M_PI);
    return [XPObject number:res];
}

@end
