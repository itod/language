//
//  FNAtan2.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNAtan2.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNAtan2

+ (NSString *)name {
    return @"atan2";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *y = [XPSymbol symbolWithName:@"y"];
    XPSymbol *x = [XPSymbol symbolWithName:@"x"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:y, x, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      y, @"y",
                      x, @"x",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *y = [space objectForName:@"y"]; TDAssert(y);
    XPObject *x = [space objectForName:@"x"]; TDAssert(x);

    [self checkNumberArgument:x];
    [self checkNumberArgument:y];

    double res = atan2(y.doubleValue, x.doubleValue);
    return [XPObject number:res];
}

@end
