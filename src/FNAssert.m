//
//  FNAssert.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNAssert.h"
#import "XPObject.h"
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPException.h"

@implementation FNAssert

+ (NSString *)name {
    return @"assert";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *test = [XPSymbol symbolWithName:@"test"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:test, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      test, @"test",
                      nil];
    
    return funcSym;
}


- (XPObject *)callInSpace:(XPMemorySpace *)space {
    TDAssert(space);
    
    XPObject *test = [space objectForName:@"test"];
    TDAssert(test);
    
    BOOL yn = [test boolValue];
    
    if (!yn) {
        NSString *str = [test stringValue];
        NSLog(@"%@", str);
        [XPException raise:XPExceptionAssertionFailed format:@"assertion failed: `%@`", str];
    }
    
    return nil;
}

@end
