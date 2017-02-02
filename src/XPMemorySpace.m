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
@property (nonatomic, retain, readwrite) NSMutableDictionary<NSString *, id> *members;
@end

@implementation XPMemorySpace

- (instancetype)init {
    TDAssert(0);
    self = [self initWithName:nil];
    return self;
}


- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
        self.members = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.members = nil;
    [super dealloc];
}


- (id)objectForName:(NSString *)name {
    TDAssertMainThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    return [_members objectForKey:name];
}


- (void)setObject:(id)obj forName:(NSString *)name {
    TDAssertMainThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    [_members setObject:obj forKey:name];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %@>", _name, _members];
}

@end
