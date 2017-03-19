//
//  FNRange.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNRange.h"
#import <Language/XPObject.h>
#import "XPNumberClass.h"
#import "XPArrayClass.h"
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

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
    
    [funcSym setDefaultObject:[XPObject nanObject] forParamNamed:@"b"];
    [funcSym setDefaultObject:[XPObject number:1] forParamNamed:@"step"];
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker argc:(NSUInteger)argc {
    XPMemorySpace *space = walker.currentSpace;
    TDAssert(space);
    
    // calc start, stop, step
    NSInteger start = 0;
    NSInteger stop = 0;
    NSInteger step = 0;
    {
        XPObject *aObj = [space objectForName:@"a"];           TDAssert(aObj);
        XPObject *bObj = [space objectForName:@"b"];           TDAssert(bObj);
        XPObject *stepObj = [space objectForName:@"step"];     TDAssert(stepObj);
        
        double a = [aObj doubleValue];
        double b = [bObj doubleValue];
        step = [stepObj doubleValue];
        
        BOOL singleArgGiven = isnan(b);
        
        if (singleArgGiven) {
            start = 1;
            stop = a;
        } else {
            start = a;
            stop = b;
        }
    }
    
    // build array
    XPObject *arrObj = nil;
    {
        NSMutableArray *v = [NSMutableArray arrayWithCapacity:labs(stop-start)];
        
//        for (NSInteger i = start; i <= stop; i = start+i*step) {
        for (NSInteger i = start; i > 0 && i <= stop; i += step) {
            XPObject *obj = [XPObject number:i];
            [v addObject:obj];
        }
        
        arrObj = [XPArrayClass instanceWithValue:v];
    }

    return arrObj;
}

@end
