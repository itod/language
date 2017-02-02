//
//  XPNode.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPNode.h"

@interface XPNode ()
@property (nonatomic, retain) NSMutableArray *kids;
@end

@implementation XPNode

+ (instancetype)nodeWithToken:(PKToken *)tok {
    return [[[self alloc] initWithToken:tok] autorelease];
}


- (instancetype)init {
    return [self initWithToken:nil];
}


- (instancetype)initWithToken:(PKToken *)tok {
    self = [super init];
    if (self) {
        self.token = tok;
    }
    return self;
}


- (void)dealloc {
    self.token = nil;
    self.kids = nil;
    self.scope = nil;
    [super dealloc];
}


- (id)copyWithZone:(NSZone *)zone {
    TDAssertMainThread();
    XPNode *that = [[[self class] alloc] initWithToken:_token];
    that->_kids = [_kids mutableCopyWithZone:zone];
    return that;
}


- (BOOL)isEqual:(id)obj {
    if (![obj isMemberOfClass:[self class]]) {
        return NO;
    }
    
    XPNode *that = (XPNode *)obj;
    
    if (![_token isEqual:that->_token]) {
        return NO;
    }
    
    if (_kids && that->_kids && ![_kids isEqualToArray:that->_kids]) {
        return NO;
    }
    
    return YES;
}


- (NSString *)description {
    return [self treeDescription];
}


- (NSString *)treeDescription {
    if (![_kids count]) {
        return self.name;
    }
    
    NSMutableString *ms = [NSMutableString string];
    
    if (![self isNil]) {
        [ms appendFormat:@"(%@ ", self.name];
    }
    
    NSInteger i = 0;
    for (XPNode *kid in _kids) {
        NSString *fmt = 0 == i++ ? @"%@" : @" %@";
        [ms appendFormat:fmt, [kid treeDescription]];
    }
    
    if (![self isNil]) {
        [ms appendString:@")"];
    }
    
    return [[ms copy] autorelease];
}


- (NSUInteger)type {
    NSAssert2(0, @"%s is an abastract method. Must be overridden in %@", __PRETTY_FUNCTION__, NSStringFromClass([self class]));
    return NSNotFound;
}


- (BOOL)isNil {
    return !_token;
}


- (NSString *)name {
    return [_token stringValue];
}


#pragma mark -
#pragma mark Child Access

- (void)addChild:(XPNode *)a {
    TDAssertMainThread();
    TDAssert(a);
    if (!_kids) {
        self.kids = [NSMutableArray array];
    }
    [_kids addObject:a];
}


- (id)childAtIndex:(NSUInteger)i {
    TDAssertMainThread();
    TDAssert(NSNotFound != i);
    TDAssert(_kids);
    TDAssert(i < [_kids count]);
    return _kids[i];
}


- (void)replaceChild:(XPNode *)node atIndex:(NSUInteger)i {
    TDAssertMainThread();
    TDAssert([node isKindOfClass:[XPNode class]]);
    TDAssert(NSNotFound != i);
    TDAssert(_kids);
    TDAssert(i < [_kids count]);
    _kids[i] = node;
}


- (NSArray *)children {
    TDAssertMainThread();
    return [[_kids copy] autorelease];
}

@end
