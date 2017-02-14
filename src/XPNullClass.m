//
//  XPNullClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPNullClass.h"
#import "XPObject.h"

@implementation XPNullClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPNullClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (NSString *)name {
    return @"null";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];
    TDAssert(sel);
    return sel;
}


- (id)stringValue:(XPObject *)this {
    return @"";
}


- (id)doubleValue:(XPObject *)this {
    return @0;
}


- (id)boolValue:(XPObject *)this {
    return @NO;
}


@end
