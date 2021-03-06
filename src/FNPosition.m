//
//  FNPosition.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNPosition.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPException.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"
#import "XPNumberClass.h"

@implementation FNPosition

+ (NSString *)name {
    return @"position";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    funcSym.returnType = [XPNumberClass classInstance];
    
    XPSymbol *seq = [XPSymbol symbolWithName:@"sequence"];
    XPSymbol *obj = [XPSymbol symbolWithName:@"object"];
    XPSymbol *identity = [XPSymbol symbolWithName:@"compareIdentity"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:seq, obj, identity, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      seq, @"sequence",
                      obj, @"object",
                      identity, @"compareIdentity",
                      nil];
    
    [funcSym setDefaultObject:[XPObject falseObject] forParamNamed:@"compareIdentity"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *seq = [space objectForName:@"sequence"];
    TDAssert(seq);
    XPObject *obj = [space objectForName:@"object"];
    TDAssert(obj);
    BOOL identity = [[space objectForName:@"compareIdentity"] boolValue];
    
    NSUInteger idx = NSNotFound;
    
    if ([seq isArrayObject]) {
        if (identity) {
            idx = [seq.value indexOfObjectIdenticalTo:obj];
        } else {
            idx = [seq.value indexOfObject:obj];
        }
    } else if ([seq isStringObject]) {
        NSString *v = [seq stringValue];
        if (identity) {
            if (obj.isStringObject) {
                idx = [v rangeOfString:[obj stringValue]].location;
            } else {
                idx = NSNotFound;
            }
        } else {
            idx = [v rangeOfString:[obj stringValue]].location;
        }
    } else {
        [self raise:XPTypeError format:@"first argument to `position()` must be an Array or String object"];
        return nil;
    }
    
    double res = NSNotFound == idx ? 0 : idx+1;
    
    return [XPObject number:res];
}

@end
