//
//  FNSleep.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNSleep.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

@implementation FNSleep

+ (NSString *)name {
    return @"sleep";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *secs = [XPSymbol symbolWithName:@"seconds"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:secs, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      secs, @"secondss",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *secsObj = [walker.currentSpace objectForName:@"seconds"];
    
    double secs = [secsObj doubleValue];
    sleep(secs);
    
    return nil;
}

@end
