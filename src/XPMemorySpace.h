//
//  XPMemorySpace.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;

@interface XPMemorySpace : NSObject <NSCopying>

- (instancetype)initWithName:(NSString *)name enclosingSpace:(XPMemorySpace *)space;

- (BOOL)containsObjectForName:(NSString *)name;
- (XPObject *)objectForName:(NSString *)name;
- (void)setObject:(XPObject *)obj forName:(NSString *)name;

- (void)addMembers:(NSMutableDictionary<NSString *, XPObject *> *)members;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, retain, readonly) XPMemorySpace *enclosingSpace;
@property (nonatomic, retain, readonly) XPMemorySpace *debugEnclosingSpace;

// returns members placed exactly in this memory space
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, XPObject *> *members;

// returns members placed in this memory space plus members accessible in enclosing space too (recursively)
// this is useful for <local> spaces, where you want enclosing members too
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, XPObject *> *allMembers;

// DEBUG
@property (nonatomic, assign) BOOL wantsPause;
@property (nonatomic, assign) NSUInteger lineNumber;
@end
