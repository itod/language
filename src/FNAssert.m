//
//  FNAssert.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNAssert.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

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
    
    [funcSym setDefaultObject:[XPObject string:@""] forParamNamed:@"message"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *test = [space objectForName:@"test"];
    TDAssert(test);
    NSString *msg = [[space objectForName:@"message"] stringValue];
    
    BOOL yn = [test boolValue];
    
    if (!yn) {
        NSString *str = [test stringValue];
        [self raise:XPAssertionError format:@"assertion failed: `%@`, %@", str, msg];
    }
    
    return nil;
}

@end
