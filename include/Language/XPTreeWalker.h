//
//  XPTreeWalker.h
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPNode;
@class XPObject;
@class XPGlobalScope;
@class XPMemorySpace;
@class XPTreeWalker;
@class XPBreakpointCollection;

@protocol XPTreeWalkerDelegate <NSObject>
- (void)treeWalker:(XPTreeWalker *)w didPause:(NSDictionary *)debugInfo;
- (BOOL)shouldPauseForTreeWalker:(XPTreeWalker *)w;
@end

@interface XPTreeWalker : NSObject

- (instancetype)initWithDelegate:(id <XPTreeWalkerDelegate>)d;

- (id)walk:(XPNode *)root;
- (XPObject *)loadVariableReference:(XPNode *)node;
- (XPMemorySpace *)spaceWithSymbolNamed:(NSString *)name;
- (void)raise:(NSString *)name node:(XPNode *)node format:(NSString *)fmt, ...;

- (id)block:(XPNode *)node;
- (id)block:(XPNode *)node withVars:(NSDictionary<NSString *, XPObject *> *)vars;
- (id)funcBlock:(XPNode *)node;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPMemorySpace *currentSpace;
@property (nonatomic, retain) XPMemorySpace *closureSpace;

@property (nonatomic, retain) NSFileHandle *stdOut;
@property (nonatomic, retain) NSFileHandle *stdErr;

@property (nonatomic, retain) NSMutableArray<XPMemorySpace *> *callStack;

@property (nonatomic, assign) id <XPTreeWalkerDelegate>delegate; // weakref
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, assign) BOOL wantsPauseOnCall;
@property (nonatomic, assign) BOOL wantsPauseOnReturn;
@property (nonatomic, retain) XPBreakpointCollection *breakpointCollection;
@property (nonatomic, copy) NSString *currentFilePath;
@end
