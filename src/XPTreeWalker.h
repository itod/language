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
- (void)raise:(NSString *)name node:(XPNode *)node format:(NSString *)fmt, ...;

- (void)block:(XPNode *)node;
//- (void)varDecl:(XPNode *)node;
//- (void)assign:(XPNode *)node;
//- (void)funcDecl:(XPNode *)node;
//- (id)funcCall:(XPNode *)node;
//- (void)returnStat:(XPNode *)node;
//- (void)whileBlock:(XPNode *)node;
//- (id)ifBlock:(XPNode *)node;
//- (void)elseBlock:(XPNode *)node;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPMemorySpace *currentSpace;

@property (nonatomic, retain) NSMutableArray<XPMemorySpace *> *stack;
@end
