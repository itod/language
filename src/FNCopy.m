//
//  FNCopy.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNCopy.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPClass.h"

@implementation FNCopy

+ (NSString *)name {
    return @"copy";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPClass classInstance];
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    //XPSymbol *deep = [XPSymbol symbolWithName:@"deep"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
//    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, deep, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"object",
//                      deep, @"deep",
                      nil];
    
//    [funcSym setDefaultObject:[XPObject falseObject] forParamNamed:@"deep"];
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    
    XPObject *res = [obj callInstanceMethodNamed:@"copy"];
    TDAssert([res isKindOfClass:[XPObject class]]);
    
    return res;
}

@end
