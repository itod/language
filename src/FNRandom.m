//
//  FNRandom.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "FNRandom.h"
#import <Language/XPObject.h>
#import <Language/XPTreeWalker.h>
#import "XPFunctionSymbol.h"
#import "XPMemorySpace.h"

//NSInteger random_number(NSInteger min_num, NSInteger max_num)
//{
//    NSInteger result = 0, low_num = 0, hi_num = 0;
//    
//    if (min_num < max_num)
//    {
//        low_num = min_num;
//        hi_num = max_num + 1; // include max_num in output
//    } else {
//        low_num = max_num + 1; // include max_num in output
//        hi_num = min_num;
//    }
//    
//    srand((unsigned int)time(NULL));
//    result = (rand() % (hi_num - low_num)) + low_num;
//    return result;
//}

NSData *PARandomDataOfLength(NSUInteger len) {
    assert(len > 0);
    assert(NSNotFound != len);
    return [[NSFileHandle fileHandleForReadingAtPath:@"/dev/urandom"] readDataOfLength:len];
}

NSInteger random_number(NSInteger min_num, NSInteger max_num)
{
    NSInteger result = 0, low_num = 0, hi_num = 0;

    if (min_num < max_num)
    {
        low_num = min_num;
        hi_num = max_num + 1; // include max_num in output
    } else {
        low_num = max_num + 1; // include max_num in output
        hi_num = min_num;
    }

    NSUInteger len = sizeof(NSUInteger);
    NSData *data = PARandomDataOfLength(len);
    
    NSUInteger rand;
    [data getBytes:&rand length:len];

    result = (rand % (hi_num - low_num)) + low_num;
    return result;
}

@implementation FNRandom

+ (NSString *)name {
    return @"random";
}


- (XPFunctionSymbol *)symbol {
    XPFunctionSymbol *funcSym = [XPFunctionSymbol symbolWithName:[[self class] name] enclosingScope:nil];
    funcSym.nativeBody = self;
    
    XPSymbol *low = [XPSymbol symbolWithName:@"low"];
    XPSymbol *high = [XPSymbol symbolWithName:@"high"];
    funcSym.orderedParams = [NSMutableArray arrayWithObjects:low, high, nil];
    funcSym.params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      low, @"low",
                      high, @"high",
                      nil];
    
    [funcSym setDefaultObject:[XPObject nullObject] forParamNamed:@"high"];
    
    return funcSym;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    XPObject *low = [space objectForName:@"low"]; TDAssert(low);
    XPObject *high = [space objectForName:@"high"]; TDAssert(high);
    
    if (1 == argc) {
        high = low;
        low = [XPObject number:0];
    }
    
    NSInteger res = random_number(low.doubleValue, high.doubleValue);
    return [XPObject number:res];
}

@end
