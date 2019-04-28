//
//  FNReversed.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNReversed.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNReversed

+ (NSString *)name {
    return @"reversed";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
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

    XPObject *res = nil;
    if ([seq isStringObject]) {
        NSString *inStr = seq.value;
        NSUInteger c = [inStr length];
        NSMutableString *outStr = [NSMutableString stringWithCapacity:c];
        for (NSUInteger i = c-1; i >= 0; --i) {
            [outStr appendFormat:@"%C", [inStr characterAtIndex:i]];
        }
        res = [XPObject string:outStr];
    } else if ([seq isArrayObject]) {
        NSArray *inVec = seq.value;
        NSMutableArray *outVec = [NSMutableArray arrayWithCapacity:[inVec count]];
        for (id obj in [inVec reverseObjectEnumerator]) {
            [outVec addObject:obj];
        }
        res = [XPObject array:outVec];
    }
    
    return res;
}

@end
