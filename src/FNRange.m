//
//  FNRange.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNRange.h"
#import "XPFunctionSymbol.h"

@implementation FNRange

+ (NSString *)name {
    return @"range";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *a = [XPSymbol symbolWithName:@"a"];
    XPSymbol *b = [XPSymbol symbolWithName:@"b"];
    XPSymbol *step = [XPSymbol symbolWithName:@"step"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:a, b, step, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      a, @"a",
                      b, @"b",
                      step, @"step",
                      nil];

    return funcSym;
}


- (XPObject *)call {
    
    
    
    return nil;
}

@end
