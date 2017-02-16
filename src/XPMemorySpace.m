//
//  XPMemorySpace.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPMemorySpace.h"

@interface XPMemorySpace ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, retain, readwrite) XPMemorySpace *enclosingSpace;
@property (nonatomic, retain, readwrite) NSMutableDictionary<NSString *, XPObject *> *members;
@end

@implementation XPMemorySpace

- (instancetype)init {
    TDAssert(0);
    self = [self initWithName:nil enclosingSpace:nil];
    return self;
}


- (instancetype)initWithName:(NSString *)name enclosingSpace:(XPMemorySpace *)space {
    self = [super init];
    if (self) {
        self.name = name;
        self.enclosingSpace = space;
        self.members = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.members = nil;
    [super dealloc];
}


- (XPObject *)objectForName:(NSString *)name {
    TDAssertMainThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    XPObject *obj = [_members objectForKey:name];
    
    if (!obj) {
        obj = [_enclosingSpace objectForName:name];
    }
    
    return obj;
}


- (void)setObject:(XPObject *)obj forName:(NSString *)name {
    TDAssertMainThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    [_members setObject:obj forKey:name];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %@>", _name, _members];
}

@end
