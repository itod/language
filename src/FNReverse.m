//
//  FNReverse.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNReverse.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) id value;
@end

@implementation FNReverse

+ (NSString *)name {
    return @"reverse";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *array = [XPSymbol symbolWithName:@"array"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:array, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      array, @"array",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *array = [space objectForName:@"array"];
    TDAssert(array);

    if (![array isArrayObject]) {
        [self raise:XPTypeError format:@"first argument to `reverse()` must be an Array object"];
        return nil;
    }
    
    NSArray *inVec = array.value;
    NSMutableArray *outVec = [NSMutableArray arrayWithCapacity:[inVec count]];
    for (id obj in [inVec reverseObjectEnumerator]) {
        [outVec addObject:obj];
    }
    array.value = outVec;
    
    return nil;
}

@end
