//
//  FNInsert.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNInsert.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPIndexException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNullClass.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) id value;
@end

@implementation FNInsert

+ (NSString *)name {
    return @"insert";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNullClass classInstance];
    
    XPSymbol *array = [XPSymbol symbolWithName:@"array"];
    XPSymbol *idx = [XPSymbol symbolWithName:@"index"];
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:array, idx, obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      array, @"array",
                      idx, @"index",
                      obj, @"object",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *array = [space objectForName:@"array"];
    TDAssert(array);
    
    if (![array isArrayObject]) {
        [self raise:XPTypeError format:@"first argument to `insert()` must be an Array object"];
        return nil;
    }
    
    XPObject *idx = [space objectForName:@"index"];
    TDAssert(idx);
    
    NSInteger i = idx.integerValue;

    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    
    [array callInstanceMethodNamed:@"insert" withArgs:@[@(i), obj]]; // throws XPIndexError
    
    return nil;
}

@end
