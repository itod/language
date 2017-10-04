//
//  FNSum.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNSum.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNSum

+ (NSString *)name {
    return @"sum";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *coll = [XPSymbol symbolWithName:@"collection"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:coll, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      coll, @"collection",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *coll = [space objectForName:@"collection"];
    TDAssert(coll);
    
    if (![coll isArrayObject]) {
        [self raise:XPTypeError format:@"argument to `sum()` must be an Array object"];
        return nil;
    }
    
    NSArray *vec = coll.value;
    double result = 0.0;
    
    for (XPObject *item in vec) {
        TDAssert([item isKindOfClass:[XPObject class]]);
        
        result += [item doubleValue];
    }
    
    return [XPObject number:result];
}
@end
