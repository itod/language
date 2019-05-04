//
//  FNOrd.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNOrd.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNOrd

+ (NSString *)name {
    return @"ord";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *str = [XPSymbol symbolWithName:@"string"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:str, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      str, @"string",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *obj = [space objectForName:@"string"];
    TDAssert(obj);
    
    if (!obj.isStringObject) {
        [self raise:XPTypeError format:@"ord() expected String of length 1, but '%@' found", [obj.objectClass name]];
        return nil;
    }
    
    NSString *str = obj.value;
    if (1 != [str length]) {
        [self raise:XPTypeError format:@"ord() expected String of length 1, but %@ found", obj.reprValue];
        return nil;
    }
    
    unichar c = [str characterAtIndex:0];
    
    XPObject *res = [XPObject number:c];
    return res;
}

@end
