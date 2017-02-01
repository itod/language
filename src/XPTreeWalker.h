//
//  XPTreeWalker.h
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XP_TOKEN_KIND_BLOCK -2

@class XPNode;
@class XPGlobalScope;
@class XPMemorySpace;

@interface XPTreeWalker : NSObject

- (void)walk:(XPNode *)root;

- (void)raise:(NSString *)name node:(XPNode *)node format:(NSString *)fmt, ...;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPMemorySpace *currentSpace;
@end
