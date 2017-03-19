//
//  FNCompare.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNCompare.h"
#import <Language/XPObject.h>
#import "XPNumberClass.h"
#import "XPFunctionSymbol.h"
#import <Language/XPTreeWalker.h>
#import "XPMemorySpace.h"

@implementation FNCompare

+ (NSString *)name {
    return @"compare";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *lhs = [XPSymbol symbolWithName:@"lhs"];
    XPSymbol *rhs = [XPSymbol symbolWithName:@"rhs"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:lhs, rhs, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      lhs, @"lhs",
                      rhs, @"rhs",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    XPObject *lhs = [space objectForName:@"lhs"];
    TDAssert(lhs);
    XPObject *rhs = [space objectForName:@"rhs"];
    TDAssert(rhs);
    
    NSString *lhsStr = [lhs stringValue];
    NSString *rhsStr = [rhs stringValue];
    
    double res = [lhsStr compare:rhsStr];
    
    return [XPObject number:res];
}

@end
