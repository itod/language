//
//  XPArrayClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPArrayClass.h"
#import "XPObject.h"

@implementation XPArrayClass

- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = NULL;

    if ([methName isEqualToString:@"length"]) {
        sel = @selector(length:);
    } if ([methName isEqualToString:@"stringValue"]) {
        sel = @selector(stringValue:);
    } if ([methName isEqualToString:@"doubleValue"]) {
        sel = @selector(doubleValue:);
    } if ([methName isEqualToString:@"boolValue"]) {
        sel = @selector(boolValue:);
    } else if ([methName isEqualToString:@"get"]) {
        sel = @selector(get::);
    } else if ([methName isEqualToString:@"set"]) {
        sel = @selector(set:::);
    } else if ([methName isEqualToString:@"append"]) {
        sel = @selector(append::);
    }
    TDAssert(sel);

    return sel;
}


- (id)length:(XPObject *)this {
    NSMutableArray *v = this.value;
    NSInteger c = [v count];
    return @(c);
}


- (id)get:(XPObject *)this :(NSInteger)idx {
    NSMutableArray *v = this.value;
    id res = [v objectAtIndex:idx];
    return res;
}


- (void)set:(XPObject *)this :(NSInteger)idx :(id)obj {
    NSMutableArray *v = this.value;
    [v replaceObjectAtIndex:idx withObject:obj];
}


- (void)append:(XPObject *)this :(id)obj {
    NSMutableArray *v = this.value;
    [v addObject:obj];
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
