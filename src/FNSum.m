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
#import "XPNumberClass.h"

@implementation FNSum

+ (NSString *)name {
    return @"sum";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *seq = [XPSymbol symbolWithName:@"sequence"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:seq, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      seq, @"sequence",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *seq = [space objectForName:@"sequence"];
    TDAssert(seq);
    
    if (![seq isArrayObject]) {
        [self raise:XPTypeError format:@"argument to `sum()` must be an Array object"];
        return nil;
    }
    
    NSArray *vec = seq.value;
    double result = 0.0;
    
    for (XPObject *item in vec) {
        TDAssert([item isKindOfClass:[XPObject class]]);
        
        result += [item doubleValue];
    }
    
    return [XPObject number:result];
}

@end
