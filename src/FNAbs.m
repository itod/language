//
//  FNAbs.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNAbs.h"
#import <Language/XPObject.h>
#import "XPFunctionSymbol.h"
#import <Language/XPTreeWalker.h>
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNAbs

+ (NSString *)name {
    return @"abs";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"object",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    
    double res = fabs(obj.doubleValue);
    return [XPObject number:res];
}

@end