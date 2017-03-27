//
//  FNMax.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNMax.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNMax

+ (NSString *)name {
    return @"max";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *a = [XPSymbol symbolWithName:@"a"];
    XPSymbol *b = [XPSymbol symbolWithName:@"b"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:a, b, nil];
    funcSym.defaultParamObjects = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   [XPObject number:-MAXFLOAT], @"b",
                                   nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      a, @"a",
                      b, @"b",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *aObj = [space objectForName:@"a"]; TDAssert(aObj);
    XPObject *bObj = [space objectForName:@"b"]; TDAssert(bObj);
    
    double res = -MAXFLOAT;
    
    if (1 == argc && aObj.isArrayObject) {
        NSArray *v = aObj.value;
        for (XPObject *obj in v) {
            res = MAX(res, obj.doubleValue);
        }
    } else {
        res = MAX(aObj.doubleValue, bObj.doubleValue);
    }
    
    return [XPObject number:res];
}

@end
