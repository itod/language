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
        self.lineNumber = NSNotFound;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.enclosingSpace = nil;
    self.members = nil;
    [super dealloc];
}


- (BOOL)containsObjectForName:(NSString *)name {
    TDAssertExecuteThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    XPObject *obj = [_members objectForKey:name];
    return nil != obj;
}


- (XPObject *)objectForName:(NSString *)name {
    TDAssertExecuteThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    XPObject *obj = [_members objectForKey:name];
    
    if (!obj) {
        obj = [_enclosingSpace objectForName:name];
    }
    
    return obj;
}


- (void)setObject:(XPObject *)obj forName:(NSString *)name {
    TDAssertExecuteThread();
    TDAssert([name length]);
    TDAssert(_members);
    
    [_members setObject:obj forKey:name];
}


- (void)addMembers:(NSMutableDictionary<NSString *, XPObject *> *)members {
    TDAssertExecuteThread();
    TDAssert(members);
    TDAssert(_members);
    
    for (NSString *name in members) {
        XPObject *obj = members[name];
        [_members setObject:obj forKey:name];
    }
}


- (NSMutableDictionary *)allMembers {
    NSMutableDictionary *res = nil;
    if (_enclosingSpace) {
        TDAssert([self isKindOfClass:NSClassFromString(@"XPLocalSpace")]);
        res = [NSMutableDictionary dictionaryWithDictionary:[_enclosingSpace allMembers]];
        [res addEntriesFromDictionary:self.members];
    } else {
        TDAssert([self isKindOfClass:NSClassFromString(@"XPGlobalSpace")] || [self isKindOfClass:NSClassFromString(@"XPFunctionSpace")]);
        res = self.members;
    }
    return res;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %@>", _name, _members];
}

@end
