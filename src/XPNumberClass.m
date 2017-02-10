//
//  XPNumberClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPNumberClass.h"
#import "XPObject.h"

@implementation XPNumberClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPNumberClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];
    TDAssert(sel);
    return sel;
}


- (id)stringValue:(XPObject *)this {
    return [NSString stringWithFormat:@"%@", this.value];
}


- (id)doubleValue:(XPObject *)this {
    return this.value;
}


- (id)boolValue:(XPObject *)this {
    double d = [this.value doubleValue];
    return (d != 0.0 && !isnan(d)) ? @YES : @NO;
}


@end
