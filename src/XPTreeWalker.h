//
//  XPTreeWalker.h
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPNode;
@class XPValue;
@class XPGlobalScope;
@class XPMemorySpace;

@interface XPTreeWalker : NSObject

- (id)walk:(XPNode *)root;
- (XPValue *)loadVariableReference:(XPNode *)node;
- (XPMemorySpace *)spaceWithSymbolNamed:(NSString *)name;
- (void)raise:(NSString *)name node:(XPNode *)node format:(NSString *)fmt, ...;

- (void)block:(XPNode *)node;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPMemorySpace *currentSpace;

@property (nonatomic, retain) NSMutableArray<XPMemorySpace *> *stack;
@end
