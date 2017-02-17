//
//  XPArrayClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPArrayClass.h"
#import "XPObject.h"
#import "XPEnumeration.h"

@implementation XPArrayClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPArrayClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (NSString *)name {
    return @"Array";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];

    if ([methName isEqualToString:@"count"]) {
        sel = @selector(length:);
    } else if ([methName isEqualToString:@"get"]) {
        sel = @selector(get::);
    } else if ([methName isEqualToString:@"set"]) {
        sel = @selector(set:::);
    } else if ([methName isEqualToString:@"append"]) {
        sel = @selector(append::);
    } else if ([methName isEqualToString:@"slice"]) {
        sel = @selector(slice::::);
    
//    } else if ([methName isEqualToString:@"indexOf"]) {
//        sel = @selector(indexOf::);

    }
    TDAssert(sel);

    return sel;
}


- (XPEnumeration *)enumeration:(XPObject *)this {
    XPEnumeration *e = [XPEnumeration enumerationWithValues:[[this.value copy] autorelease]];
    return e;
}


- (id)length:(XPObject *)this {
    NSMutableArray *v = this.value;
    NSInteger c = [v count];
    return @(c);
}


- (NSInteger)nativeIndexForIndex:(NSInteger)inIdx inArray:(NSArray *)v {
    NSInteger outIdx = inIdx;
    
    if (inIdx < 0) {
        NSUInteger c = [v count];
        outIdx = c+outIdx;
    } else {
        outIdx = inIdx-1;
    }
    
    return outIdx;
}


- (XPObject *)get:(XPObject *)this :(NSInteger)idx {
    NSMutableArray *v = this.value;
    idx = [self nativeIndexForIndex:idx inArray:v];
    id res = [v objectAtIndex:idx];
    return res;
}


- (void)set:(XPObject *)this :(NSInteger)idx :(XPObject *)obj {
    NSMutableArray *v = this.value;
    idx = [self nativeIndexForIndex:idx inArray:v];
    [v replaceObjectAtIndex:idx withObject:obj];
}


- (void)append:(XPObject *)this :(XPObject *)obj {
    NSMutableArray *v = this.value;
    [v addObject:obj];
}


- (XPObject *)slice:(XPObject *)this :(NSInteger)start :(NSInteger)stop :(NSInteger)step {
    NSMutableArray *v = this.value;
    
    // build array
    XPObject *arrObj = nil;
    {
        NSMutableArray *res = [NSMutableArray arrayWithCapacity:labs(stop-start)];
        
        for (NSInteger i = start; i > 0 && i <= stop; i += step) {
            NSInteger j = [self nativeIndexForIndex:i inArray:v];
            XPObject *obj = [v objectAtIndex:j];
            [res addObject:obj];
        }
        
        arrObj = [XPArrayClass instanceWithValue:res];
    }
    
    return arrObj;
}


- (id)stringValue:(XPObject *)this {
    NSMutableString *buf = [NSMutableString stringWithString:@"["];
    
    TDAssert(this.value);
    NSUInteger c = [this.value count];
    NSUInteger i = 0;
    for (id obj in this.value) {
        [buf appendFormat:@"%@%@", [obj stringValue], i++ == c-1 ? @"" : @","];
    }
    
    [buf appendString:@"]"];
    
    return buf;
}


- (id)doubleValue:(XPObject *)this {
    return [this.value count] > 0 ? @1.0 : @0.0;
}


- (id)boolValue:(XPObject *)this {
    return [this.value count] > 0 ? @YES : @NO;
}

@end
