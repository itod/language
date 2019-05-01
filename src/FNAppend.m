//
//  FNAppend.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNAppend.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) id value;
@end

@implementation FNAppend

+ (NSString *)name {
    return @"append";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *array = [XPSymbol symbolWithName:@"array"];
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:array, obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      array, @"array",
                      obj, @"object",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *array = [space objectForName:@"array"];
    TDAssert(array);
    
    if (![array isArrayObject]) {
        [self raise:XPTypeError format:@"first argument to `append()` must be an Array object"];
        return nil;
    }
    
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    
    [array.value addObject:obj];
    
    return nil;
}

@end
