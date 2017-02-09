//
//  XPClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPClass.h"

@implementation XPClass

- (XPObject *)internedObjectWithValue:(id)val {
    return nil;
}


- (NSMethodSignature *)getInvocation:(NSInvocation **)outInvoc forMethodNamed:(NSString *)methName {
    SEL sel = [self selectorForMethodNamed:methName];
    TDAssert(sel);

    NSMethodSignature *sig = [self methodSignatureForSelector:sel];
    TDAssert(sig);
    
    NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:sig];
    [invoc setSelector:sel];
    [invoc setTarget:self];
    TDAssert(invoc);
    *outInvoc = invoc;
    
    return sig;
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return NULL;
}

@end
