//
//  FNAssert.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNAssert.h"
#import "XPObject.h"
#import "XPStringClass.h"
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
    XPSymbol *msg = [XPSymbol symbolWithName:@"message"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:test, msg, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      test, @"test",
                      msg, @"message",
                      nil];
    
    [funcSym setDefaultObject:[XPStringClass instanceWithValue:@""] forParamNamed:@"message"];
    
    return funcSym;
}


- (XPObject *)callInSpace:(XPMemorySpace *)space walker:(id)walker {
    TDAssert(space);
    
    XPObject *test = [space objectForName:@"test"];
    TDAssert(test);
    NSString *msg = [[space objectForName:@"message"] stringValue];
    
    BOOL yn = [test boolValue];
    
    if (!yn) {
        NSString *str = [test stringValue];
        NSLog(@"Assertion Failed: `%@`, %@", str, msg);
        [XPException raise:XPExceptionAssertionFailed format:@"assertion failed: `%@`, %@", str, msg];
    }
    
    return nil;
}

@end
