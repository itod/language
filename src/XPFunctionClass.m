//
//  XPFunctionClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionClass.h"
#import "XPObject.h"

@implementation XPFunctionClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPFunctionClass *cls = nil;
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
    return @"[object Function]"; // TODO
}


- (id)doubleValue:(XPObject *)this {
    return @1;
}


- (id)boolValue:(XPObject *)this {
    return @YES;
}

@end
