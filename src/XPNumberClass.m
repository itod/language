//
//  XPNumberClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPNumberClass.h"
#import <Language/XPObject.h>

@interface XPObject ()
- (instancetype)initWithClass:(XPClass *)cls value:(id)val;
@end

@interface XPNumberClass ()
@property (nonatomic, retain) NSMutableDictionary *cache;
@property (nonatomic, retain) XPObject *nanObject;
@property (nonatomic, retain) XPObject *positiveInfinityObject;
@property (nonatomic, retain) XPObject *negativeInfinityObject;
@end

@implementation XPNumberClass

+ (instancetype)classInstance {
    TDAssertExecuteThread();
    static XPNumberClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (void)dealloc {
    self.cache = nil;
    self.nanObject = nil;
    self.positiveInfinityObject = nil;
    self.negativeInfinityObject = nil;
    [super dealloc];
}


- (XPObject *)internedObjectWithValue:(id)val {
    TDAssertExecuteThread();
    
    XPObject *res = nil;
    
    if (isnan([val doubleValue])) {
        res = self.nanObject;
    } else {
        res = self.cache[val];
        if (!res) {
            res = [[[XPObject alloc] initWithClass:self value:val] autorelease];
            self.cache[val] = res;
        }
    }
    
    return res;
}


- (NSString *)name {
    return @"Number";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];
    TDAssert(sel);
    return sel;
}


- (id)stringValue:(XPObject *)this {
    NSString *res = nil;
    double d = [this.value doubleValue];
    if (isnan(d)) {
        TDAssert([XPObject nanObject] == this)
        res = @"NaN";
    } else if (isinf(d)) {
        if (d < 0.0) {
            TDAssert([XPObject negativeInfinityObject] == this)
            res = @"-Infinity";
        } else {
            TDAssert([XPObject positiveInfinityObject] == this)
            res = @"Infinity";
        }
    } else {
        res = [NSString stringWithFormat:@"%@", this.value];
    }
    return res;
}


- (id)doubleValue:(XPObject *)this {
    return this.value;
}


- (id)boolValue:(XPObject *)this {
    double d = [this.value doubleValue];
    return (d != 0.0 && !isnan(d)) ? @YES : @NO;
}


#pragma mark -
#pragma mark Private

- (NSMutableDictionary *)cache {
    if (!_cache) {
        self.cache = [NSMutableDictionary dictionary];
    }
    
    return _cache;
}


- (XPObject *)nanObject {
    if (!_nanObject) {
        self.nanObject = [[[XPObject alloc] initWithClass:self value:@(NAN)] autorelease];
    }
    return _nanObject;
}


- (XPObject *)positiveInfinityObject {
    if (!_positiveInfinityObject) {
        self.positiveInfinityObject = [[[XPObject alloc] initWithClass:self value:@((INFINITY))] autorelease];
    }
    return _positiveInfinityObject;
}


- (XPObject *)negativeInfinityObject {
    if (!_negativeInfinityObject) {
        self.negativeInfinityObject = [[[XPObject alloc] initWithClass:self value:@((-INFINITY))] autorelease];
    }
    return _negativeInfinityObject;
}

@end
