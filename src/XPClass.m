//
//  XPClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPClass.h"
#import "XPObject.h"

@implementation XPClass

+ (instancetype)classInstance {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


+ (XPObject *)instanceWithValue:(id)val {
    XPClass *cls = [self classInstance];
    XPObject *obj = [XPObject objectWithClass:cls value:val];
    return obj;
}


- (NSString *)name {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


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
    SEL sel = NULL;
    
    if ([methName isEqualToString:@"asString"]) {
        sel = @selector(asString:);
    } if ([methName isEqualToString:@"asNumber"]) {
        sel = @selector(asNumber:);
    } if ([methName isEqualToString:@"asBoolean"]) {
        sel = @selector(asBoolean:);

//    } if ([methName isEqualToString:@"copy"]) {
//        sel = @selector(copy:);
//    } if ([methName isEqualToString:@"type"]) {
//        sel = @selector(type:);

    }
    
    return sel;
}


- (XPEnumeration *)enumeration:(XPObject *)this {
    return nil;
}


- (XPObject *)asString:(XPObject *)this {
    return [this asStringObject];
}


- (XPObject *)asNumber:(XPObject *)this {
    return [this asNumberObject];
}


- (XPObject *)asBoolean:(XPObject *)this {
    return [this asBooleanObject];
}


- (id)stringValue:(XPObject *)this {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id)doubleValue:(XPObject *)this {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (id)boolValue:(XPObject *)this {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}

@end
