//
//  XPStringClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStringClass.h"
#import "XPObject.h"

@implementation XPStringClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPStringClass *cls = nil;
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
    return this.value;
}


- (id)doubleValue:(XPObject *)this {
    return @([this.value doubleValue]);
}


- (id)boolValue:(XPObject *)this {
    return [this.value length] ? @YES : @NO;
}

@end
