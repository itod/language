//
//  FNLog.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNLog.h"
#import "XPObject.h"
#import "XPFunctionSymbol.h"
#import "XPTreeWalker.h"
#import "XPMemorySpace.h"
#import "XPException.h"

@implementation FNLog

+ (NSString *)name {
    return @"log";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:obj, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      obj, @"object",
                      nil];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    
    NSString *str = [obj stringValue];
    [walker.stdOut writeData:[[NSString stringWithFormat:@"%@\n", str] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"%@", str);
    return nil;
}

@end
