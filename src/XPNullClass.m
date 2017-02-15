//
//  XPNullClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPNullClass.h"
#import "XPObject.h"

@interface XPObject ()
- (instancetype)initWithClass:(XPClass *)cls value:(id)val;
@end

@interface XPNullClass ()
@property (nonatomic, retain) XPObject *nullObject;
@end

@implementation XPNullClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPNullClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (void)dealloc {
    self.nullObject = nil;
    [super dealloc];
}


- (XPObject *)internedObjectWithValue:(id)val {
    TDAssertMainThread();
    return self.nullObject;
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
    return @"(null)";
}


- (id)doubleValue:(XPObject *)this {
    return @0;
}


- (id)boolValue:(XPObject *)this {
    return @NO;
}


- (XPObject *)nullObject {
    if (!_nullObject) {
        self.nullObject = [[[XPObject alloc] initWithClass:self value:[NSNull null]] autorelease];
    }
    
    return _nullObject;
}

@end
