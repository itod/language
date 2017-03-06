//
//  XPInterpreter.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPInterpreter.h"
#import "XPGlobalScope.h"
#import "XPMemorySpace.h"

#import "XPParser.h"
#import "XPNode.h"

#import "XPTreeWalkerExec.h"
#import "XPException.h"

#import "XPObject.h"
#import "XPFunctionClass.h"
#import "XPFunctionSymbol.h"

#import "FNBoolean.h"
#import "FNNumber.h"
#import "FNString.h"
#import "FNType.h"

#import "FNAssert.h"
#import "FNLog.h"

#import "FNCount.h"
#import "FNPosition.h"
#import "FNRange.h"

#import "FNMap.h"
#import "FNFilter.h"
#import "FNLocals.h"
#import "FNGlobals.h"

#import "FNTrim.h"
#import "FNLowercase.h"
#import "FNUppercase.h"
#import "FNMatches.h"
#import "FNReplace.h"
#import "FNCompare.h"

#import "FNIsNan.h"

#import <PEGKit/PKAssembly.h>

#define DEBUG_VAR_NAME @"XPDEBUG"

NSString * const XPErrorDomain = @"XPErrorDomain";
NSString * const XPErrorRangeKey = @"range";
NSString * const XPErrorLineNumberKey = @"lineNumber";

NSString * const XPDebugInfoErrorKey = @"error";
NSString * const XPDebugInfoReturnCodeKey = @"returnCode";
NSString * const XPDebugInfoFrameStackKey = @"frameStack";
NSString * const XPDebugInfoFilePathKey = @"filePath";
NSString * const XPDebugInfoLineNumberKey = @"lineNumber";

@interface XPObject ()
@property (nonatomic, assign, readwrite) BOOL isNative;
@end

@interface XPInterpreter ()
@property (nonatomic, retain) XPTreeWalker *treeWalker;
@end

@implementation XPInterpreter

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}


- (void)dealloc {
    self.globalScope = nil;
    self.root = nil;
    self.parser = nil;
    self.breakpointCollection = nil;
    self.debugDelegate = nil;
    self.stdOut = nil;
    self.stdErr = nil;
    
    self.treeWalker = nil;
    
    [super dealloc];
}


- (BOOL)interpretFileAtPath:(NSString *)path error:(NSError **)outErr {
    TDAssert([path length]);
    
    NSError *err = nil;
    NSString *src = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!src) {
        if (outErr) *outErr = err;
        return NO;
    }
    
    return [self interpretString:src filePath:path error:outErr];
}


- (BOOL)interpretString:(NSString *)input filePath:(NSString *)path error:(NSError **)outErr {
    self.globalScope = [[[XPGlobalScope alloc] init] autorelease];
    if (!_globals) {
        self.globals = [[[XPMemorySpace alloc] initWithName:@"globals" enclosingSpace:nil] autorelease];       // global memory;
    }
    
    // DECLARE NATIVE FUNCS
    {
        // types
        [self declareNativeFunction:[FNBoolean class]];
        [self declareNativeFunction:[FNNumber class]];
        [self declareNativeFunction:[FNString class]];
        [self declareNativeFunction:[FNType class]];

        // util
        [self declareNativeFunction:[FNAssert class]];
        [self declareNativeFunction:[FNLog class]];
        
        // seq
        [self declareNativeFunction:[FNCount class]];
        [self declareNativeFunction:[FNPosition class]];
        [self declareNativeFunction:[FNRange class]];
        
        // coll
        [self declareNativeFunction:[FNMap class]];
        [self declareNativeFunction:[FNFilter class]];
        [self declareNativeFunction:[FNLocals class]];
        [self declareNativeFunction:[FNGlobals class]];

        // str
        [self declareNativeFunction:[FNTrim class]];
        [self declareNativeFunction:[FNLowercase class]];
        [self declareNativeFunction:[FNUppercase class]];
        [self declareNativeFunction:[FNMatches class]];
        [self declareNativeFunction:[FNReplace class]];
        [self declareNativeFunction:[FNCompare class]];
        
        // num
        [self declareNativeFunction:[FNIsNan class]];
    }
    
    // PARSE
    {
        self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
        _parser.globalScope = _globalScope;
        _parser.globals = _globals;
        
        NSError *err = nil;
        PKAssembly *a = [_parser parseString:input error:&err];
        
        if (err) {
            NSLog(@"%@", err);
            *outErr = [self errorFromPEGKitError:err];
            return NO;
        }
        TDAssert(!(*outErr));
        
        self.root = [a pop];
        
        if (!_root) {
            *outErr = err;
            return NO;
        }
        
        self.parser = nil;
    }
    
    // EVAL WALK
    BOOL success = YES;
    
    {
        @try {
            self.treeWalker = [[[XPTreeWalkerExec alloc] initWithDelegate:self] autorelease];
            _treeWalker.globals = _globals;
            _treeWalker.stdOut = _stdOut;
            _treeWalker.stdErr = _stdErr;
            _treeWalker.debug = _debug;
            _treeWalker.breakpointCollection = _breakpointCollection;
            _treeWalker.currentFilePath = path ? path : @"<main>";
            [_treeWalker walk:_root];
            
            if (_debug) {
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0, XPDebugInfoReturnCodeKey, nil];
                [self.debugDelegate interpreter:self didFinish:info];
            }
        } @catch (XPException *ex) {
            success = NO;
            if (outErr) {
                NSString *domain = XPErrorDomain;
                NSString *name = [ex name];
                NSString *reason = [ex reason];
                NSLog(@"%@", reason);
                
                *outErr = [self errorWithDomain:domain name:name reason:reason range:ex.range lineNumber:ex.lineNumber];
            } else {
                [ex raise];
            }
            
            if (_debug) {
                NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                             @1, XPDebugInfoReturnCodeKey,
                                             *outErr, XPDebugInfoErrorKey,
                                             nil];

                [self.debugDelegate interpreter:self didFail:info];
            }

        } @finally {
            self.treeWalker = nil;
        }
    }
    
    return success;
}


- (NSError *)errorWithDomain:(NSString *)domain name:(NSString *)name reason:(NSString *)reason range:(NSRange)r lineNumber:(NSUInteger)lineNum {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    // get description
    name = name ? name : NSLocalizedString(@"A runtime exception occured.", @"");
    userInfo[NSLocalizedDescriptionKey] = name;
    
    // get reason
    reason = reason ? reason : @"";
    userInfo[NSLocalizedFailureReasonErrorKey] = reason;
    userInfo[XPErrorRangeKey] = [NSValue valueWithRange:r];
    
    id lineNumVal = nil;
    if (NSNotFound == lineNum) {
        lineNumVal = NSLocalizedString(@"Unknown", @"");
    } else {
        lineNumVal = @(lineNum);
    }
    userInfo[XPErrorLineNumberKey] = lineNumVal;
    
    // convert to NSError
    NSError *err = [NSError errorWithDomain:XPErrorDomain code:0 userInfo:[[userInfo copy] autorelease]];
    return err;
}


- (NSError *)errorFromPEGKitError:(NSError *)inErr {
    NSString *name = XPExceptionSyntaxError; //inErr.localizedDescription;
    NSString *reason = inErr.userInfo[NSLocalizedFailureReasonErrorKey];
    NSRange range = [inErr.userInfo[XPErrorRangeKey] rangeValue];
    NSUInteger lineNum = [inErr.userInfo[XPErrorLineNumberKey] unsignedIntegerValue];

    NSError *outErr = [self errorWithDomain:XPErrorDomain name:name reason:reason range:range lineNumber:lineNum];
    return outErr;
}


- (void)declareNativeFunction:(Class)cls {
    TDAssert([cls isSubclassOfClass:[XPFunctionBody class]]);
    NSString *name = [cls name];
    XPFunctionBody *body = [[[cls alloc] init] autorelease];
    
    XPFunctionSymbol *funcSym = [body symbol];
    
    // declare. dont think this is actually necessary
    TDAssert(_globalScope);
    [_globalScope defineSymbol:funcSym];
    
    // define in memory
    XPObject *obj = [XPFunctionClass instanceWithValue:funcSym];
    obj.isNative = YES;
    
    TDAssert(_globals);
    [_globals setObject:obj forName:name];
}


#pragma mark -
#pragma mark XPTreeWalkerDelegate

- (void)treeWalker:(XPTreeWalker *)w didPause:(NSMutableDictionary *)debugInfo {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(w == _treeWalker);

    TDAssert(_debugDelegate);
    [_debugDelegate interpreter:self didPause:debugInfo];
}


#pragma mark -
#pragma mark DEBUG

- (void)pause {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    
}


- (void)resume {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);

}


- (void)stepOver {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);

    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.currentSpace.wantsPause = YES;
    [self resume];
}


- (void)stepIn {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    self.treeWalker.wantsPauseOnCall = YES;
    self.treeWalker.currentSpace.wantsPause = YES;
    
    // TODO. must set wants pause on next called stack frame
    TDAssert(0);
    
    
    [self resume];
}


- (void)cont {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.currentSpace.wantsPause = NO;
    [self resume];
}


- (void)finish {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
}


- (void)print:(NSString *)exprStr {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    exprStr = [NSString stringWithFormat:@"var %@=%@;", DEBUG_VAR_NAME, exprStr];
    
    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
    
    NSMutableDictionary<NSString *, XPObject *> *mems = [[[_globals members] mutableCopy] autorelease];
    [mems addEntriesFromDictionary:self.treeWalker.currentSpace.members];
    
    XPMemorySpace *monoSpace = [[[XPMemorySpace alloc] initWithName:@"globals" enclosingSpace:nil] autorelease];
    [monoSpace addMembers:_globals.members];
    
    for (XPMemorySpace *space in [self.treeWalker.callStack reverseObjectEnumerator]) {
        [monoSpace addMembers:space.members];
    }
    
    interp.globals = monoSpace;
    
    NSError *err = nil;
    if (![interp interpretString:exprStr filePath:nil error:&err]) {
        TDAssert(err);
        NSLog(@"%@", err);
        return;
    }
    
    XPObject *obj = [interp.globals objectForName:DEBUG_VAR_NAME];
    NSString *res = [NSString stringWithFormat:@"\n%@", [obj stringValue]];
    
    TDAssert(_stdOut);
    [_stdOut writeData:[res dataUsingEncoding:NSUTF8StringEncoding]];
}

@end
