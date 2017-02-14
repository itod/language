//
//  FNCount.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNCount.h"
#import "XPObject.h"
#import "XPNumberClass.h"
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNCount

+ (NSString *)name {
    return @"count";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"obj"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"obj",
                      nil];
    
    return funcSym;
}


- (XPObject *)callInSpace:(XPMemorySpace *)space {
    TDAssert(space);
    
    XPObject *obj = [space objectForName:@"obj"];
    TDAssert(obj);
    
    NSInteger c = [[obj callInstanceMethodNamed:@"count"] integerValue];
    XPObject *res = [XPNumberClass instanceWithValue:@(c)];
    return res;
}

@end
