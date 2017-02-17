//
//  XPBooleanClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBooleanClass.h"
#import "XPObject.h"

@interface XPObject ()
- (instancetype)initWithClass:(XPClass *)cls value:(id)val;
@end

@interface XPBooleanClass ()
@property (nonatomic, retain) XPObject *trueObject;
@property (nonatomic, retain) XPObject *falseObject;
@end

@implementation XPBooleanClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPBooleanClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (void)dealloc {
    self.trueObject = nil;
    self.falseObject = nil;
    [super dealloc];
}


- (XPObject *)internedObjectWithValue:(id)val {
    TDAssertMainThread();
    XPObject *res = [val boolValue] ? self.trueObject : self.falseObject;
    return res;
}


- (NSString *)name {
    return @"Boolean";
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


- (XPObject *)trueObject {
    if (!_trueObject) {
        self.trueObject = [[[XPObject alloc] initWithClass:self value:@YES] autorelease];
    }
    
    return _trueObject;
}


- (XPObject *)falseObject {
    if (!_falseObject) {
        self.falseObject = [[[XPObject alloc] initWithClass:self value:@NO] autorelease];
    }
    
    return _falseObject;
}

@end
