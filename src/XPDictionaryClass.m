//
//  XPDictionaryClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPDictionaryClass.h"
#import <Language/XPObject.h>
#import "XPEnumeration.h"

@implementation XPDictionaryClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPDictionaryClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (NSString *)name {
    return @"Dictionary";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];

    if ([methName isEqualToString:@"count"]) {
        sel = @selector(count:);
    } else if ([methName isEqualToString:@"get"]) {
        sel = @selector(get::);
    } else if ([methName isEqualToString:@"set"]) {
        sel = @selector(set:::);
    }
    TDAssert(sel);

    return sel;
}


- (XPEnumeration *)enumeration:(XPObject *)this {
    NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:[this.value count]];
    
    for (id key in this.value) {
        id val = this.value[key];
        [pairs addObject:@[key, val]];
    }
    
    XPEnumeration *e = [XPEnumeration enumerationWithValues:pairs];
    return e;
}


- (id)count:(XPObject *)this {
    NSMutableDictionary *v = this.value;
    NSInteger c = [v count];
    return @(c);
}


- (XPObject *)get:(XPObject *)this :(XPObject *)key {
    NSMutableDictionary *tab = this.value;
    XPObject *res = [tab objectForKey:key];
    
    if (!res) {
        res = [XPObject nullObject];
    }
    
    return res;
}


- (void)set:(XPObject *)this :(XPObject *)key :(XPObject *)obj {
    NSMutableDictionary *v = this.value;
    [v setObject:obj forKey:key];
}


- (id)stringValue:(XPObject *)this {
    NSMutableString *buf = [NSMutableString stringWithString:@"{"];
    
    TDAssert(this.value);
    NSUInteger c = [this.value count];
    NSUInteger i = 0;
    for (id key in this.value) {
        XPObject *obj = this.value[key];
        [buf appendFormat:@"'%@': %@%@", [key stringValue], [obj stringValue], i++ == c-1 ? @"" : @", "];
    }
    
    [buf appendString:@"}"];
    
    return buf;
}


- (id)doubleValue:(XPObject *)this {
    return [this.value count] > 0 ? @1.0 : @0.0;
}


- (id)boolValue:(XPObject *)this {
    return [this.value count] > 0 ? @YES : @NO;
}

@end
