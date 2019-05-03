//
//  FNExtend.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNExtend.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNullClass.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) id value;
@end

@implementation FNExtend

+ (NSString *)name {
    return @"extend";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNullClass classInstance];
    
    XPSymbol *array = [XPSymbol symbolWithName:@"array"];
    XPSymbol *addition = [XPSymbol symbolWithName:@"addition"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:array, addition, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      array, @"array",
                      addition, @"addition",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *array = [space objectForName:@"array"];
    TDAssert(array);
    
    if (![array isArrayObject]) {
        [self raise:XPTypeError format:@"first argument to `extend()` must be an Array object"];
        return nil;
    }
    
    XPObject *addition = [space objectForName:@"addition"];
    TDAssert(addition);
    
    if (![addition isArrayObject]) {
        [self raise:XPTypeError format:@"second argument to `extend()` must be an Array object"];
        return nil;
    }
    
    NSMutableArray *inVec = array.value;
    NSArray *inAdd = addition.value;
    for (id obj in inAdd) {
        [inVec addObject:obj];
    }
    
    return nil;
}

@end
