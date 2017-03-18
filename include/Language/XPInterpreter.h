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

extern NSString * const XPDebugInfoReturnCodeKey;
extern NSString * const XPDebugInfoFrameStackKey;
extern NSString * const XPDebugInfoFilePathKey;
extern NSString * const XPDebugInfoLineNumberKey;

@class XPGlobalScope;
@class XPMemorySpace;
@class XPNode;
@class XPParser;

@class XPBreakpointCollection;

@class XPInterpreter;

@protocol XPInterpreterDebugDelegate <NSObject>
- (void)interpreter:(XPInterpreter *)i didPause:(NSMutableDictionary *)debugInfo;
//- (void)interpreter:(XPInterpreter *)i didFinish:(NSMutableDictionary *)debugInfo;
//- (void)interpreter:(XPInterpreter *)i didFail:(NSMutableDictionary *)debugInfo;
@end

@interface XPInterpreter : NSObject <XPTreeWalkerDelegate>

- (BOOL)interpretFileAtPath:(NSString *)path error:(NSError **)outErr;
- (BOOL)interpretString:(NSString *)input filePath:(NSString *)path error:(NSError **)outErr;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPNode *root;               // the AST represents our code memory
@property (nonatomic, retain) XPParser *parser;

@property (nonatomic, retain) NSFileHandle *stdOut;
@property (nonatomic, retain) NSFileHandle *stdErr;

// debug
@property (assign) BOOL debug;
@property (retain) XPBreakpointCollection *breakpointCollection;
@property (nonatomic, assign) id <XPInterpreterDebugDelegate>debugDelegate; // weakref
@property (nonatomic, retain, readonly) XPMemorySpace *currentMemorySpace;

- (void)updateBreakpoints:(XPBreakpointCollection *)bpColl;

- (void)stepOver; // next
- (void)stepIn; // step
- (void)cont; // continue
- (void)finish; // return
- (void)print:(NSString *)exprStr;

@end
