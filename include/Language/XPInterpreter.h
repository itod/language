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

@protocol XPInterpreterDelegate <NSObject>
@optional
- (void)interpreterDidDeclareNativeFunctions:(XPInterpreter *)i;
@end

@protocol XPInterpreterDebugDelegate <NSObject>
- (void)interpreter:(XPInterpreter *)i didPause:(NSMutableDictionary *)debugInfo;
@end

@interface XPInterpreter : NSObject <XPTreeWalkerDelegate>

- (instancetype)initWithDelegate:(id <XPInterpreterDelegate>)d;

- (id)interpretFileAtPath:(NSString *)path error:(NSError **)outErr;
- (id)interpretString:(NSString *)input filePath:(NSString *)path error:(NSError **)outErr;

- (XPNode *)parseInput:(NSString *)input error:(NSError **)outErr;
- (id)eval:(XPNode *)root filePath:(NSString *)path error:(NSError **)outErr;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPNode *root;               // the AST represents our code memory
@property (nonatomic, retain) XPParser *parser;

@property (nonatomic, retain) NSFileHandle *stdOut;
@property (nonatomic, retain) NSFileHandle *stdErr;

- (void)declareNativeFunction:(Class)cls;
- (void)declareNativeVariable:(XPObject *)obj forName:(NSString *)name;
@property (nonatomic, assign) id <XPInterpreterDelegate>delegate; // weakref

// debug
@property (assign) BOOL debug;
@property (assign) BOOL paused;
@property (retain) XPBreakpointCollection *breakpointCollection;
@property (nonatomic, assign) id <XPInterpreterDebugDelegate>debugDelegate; // weakref

- (void)updateBreakpoints:(XPBreakpointCollection *)bpColl;

- (NSArray *)completionsForPrefix:(NSString *)prefix inRange:(NSRange)range;

- (void)pause;
- (void)resume;

- (void)stepOver; // next
- (void)stepIn; // step
- (void)cont; // continue
- (void)finish; // return
- (void)print:(NSString *)exprStr;

@end
