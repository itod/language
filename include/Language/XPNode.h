//
//  XPNode.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <PEGKit/PKToken.h>

@protocol XPScope;

@interface XPNode : NSObject <NSCopying>

+ (instancetype)nodeWithToken:(PKToken *)tok;

- (instancetype)initWithToken:(PKToken *)tok;

- (void)addChild:(XPNode *)node;
- (void)addChildren:(NSArray *)nodes;
- (id)childAtIndex:(NSUInteger)i;
- (void)replaceChild:(XPNode *)node atIndex:(NSUInteger)i;
- (NSUInteger)childCount;

- (BOOL)isNil;
- (XPNode *)lineNumberNode;

@property (nonatomic, assign, readonly) NSUInteger type;
@property (nonatomic, retain, readonly) NSString *name;

@property (nonatomic, retain) PKToken *token;
@property (nonatomic, retain, readonly) NSArray *children;

@property (nonatomic, assign) id <XPScope>scope; // weakref
@end
