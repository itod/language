//
//  FNCount.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNCount.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNCount

+ (NSString *)name {
    return @"count";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *seq = [XPSymbol symbolWithName:@"sequence"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:seq, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      seq, @"sequence",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *seq = [space objectForName:@"sequence"];
    TDAssert(seq);
    
    NSInteger c = [[seq callInstanceMethodNamed:@"count"] integerValue];
    XPObject *res = [XPObject number:c];
    return res;
}

@end
