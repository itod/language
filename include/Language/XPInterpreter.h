//
//  XPInterpreter.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPTreeWalker.h>

extern NSString * const XPErrorDomain;
extern NSString * const XPErrorRangeKey;
extern NSString * const XPErrorLineNumberKey;

extern NSString * const XPDebugInfoFrameStackKey;

@class XPGlobalScope;
@class XPMemorySpace;
@class XPNode;
@class XPParser;

@class OKBreakpointCollection;

@class XPInterpreter;

@protocol XPInterpreterDebugDelegate <NSObject>
- (void)interpreter:(XPInterpreter *)i didPause:(NSDictionary *)debugInfo;
- (void)interpreter:(XPInterpreter *)i didFinish:(NSDictionary *)debugInfo;
- (void)interpreter:(XPInterpreter *)i didFail:(NSDictionary *)debugInfo;
@end

@interface XPInterpreter : NSObject <XPTreeWalkerDelegate>

- (BOOL)interpretString:(NSString *)input error:(NSError **)outErr;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPNode *root;               // the AST represents our code memory
@property (nonatomic, retain) XPParser *parser;

// debug
@property (nonatomic, assign) BOOL debug;
@property (nonatomic, retain) OKBreakpointCollection *breakpointCollection;
@property (nonatomic, assign) id <XPInterpreterDebugDelegate>debugDelegate; // weakref

- (void)stepOver; // next
- (void)stepIn; // step
- (void)cont; // continue
- (void)finish; // return

@end
