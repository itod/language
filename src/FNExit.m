//
//  FNExit.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNExit.h"
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPNullClass.h"

@implementation FNExit

+ (NSString *)name {
    return @"exit";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNullClass classInstance];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    
    [self raise:XPSystemExitException format:@"exit() called."];
    
    return nil;
}

@end
