//
//  XPBooleanClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBooleanClass.h"
#import "XPObject.h"

@implementation XPBooleanClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPBooleanClass *cls = nil;
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
    return [this.value boolValue] ? @"true" : @"false";
}


- (id)doubleValue:(XPObject *)this {
    return this.value;
}


- (id)boolValue:(XPObject *)this {
    return this.value;
}


@end
