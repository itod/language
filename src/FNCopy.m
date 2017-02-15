//
//  FNCopy.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNCopy.h"
#import "XPObject.h"
#import "XPBooleanClass.h"
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNCopy

+ (NSString *)name {
    return @"copy";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"obj"];
    //XPSymbol *deep = [XPSymbol symbolWithName:@"deep"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
//    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, deep, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"obj",
//                      deep, @"deep",
                      nil];
    
//    [funcSym setDefaultObject:[XPBooleanClass instanceWithValue:@NO] forParamNamed:@"deep"];
    return funcSym;
}


- (XPObject *)callInSpace:(XPMemorySpace *)space {
    TDAssert(space);
    
    XPObject *obj = [space objectForName:@"obj"];
    TDAssert(obj);
    
    XPObject *res = [obj callInstanceMethodNamed:@"copy"];
    TDAssert([obj isKindOfClass:[XPObject class]]);
    
    return res;
}

@end
