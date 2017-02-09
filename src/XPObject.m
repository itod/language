//
//  XPObject.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPObject.h"
#import "XPClass.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) XPClass *class;
@property (nonatomic, retain, readwrite) id value;
@end

@implementation XPObject

+ (instancetype)null {
    TDAssertMainThread();
    static XPObject *null = nil;
    if (!null) {
        null = [[XPObject alloc] initWithClass:nil value:nil];
    }
    return null;
}


+ (instancetype)objectWithClass:(XPClass *)cls value:(id)val {
    TDAssert(cls);
    TDAssert(val);
    XPObject *obj = [cls internedObjectWithValue:val];
    if (!obj) {
        obj = [[[self alloc] initWithClass:cls value:val] autorelease];
    }
    return obj;
}


- (instancetype)init {
    TDAssert(0);
    self = [super init];
    return self;
}


- (instancetype)initWithClass:(XPClass *)cls value:(id)val {
    self = [super init];
    if (self) {
        self.class = cls;
        self.value = val;
    }
    return self;
}


- (void)dealloc {
    self.class = nil;
    self.value = nil;
    [super dealloc];
}

@end
