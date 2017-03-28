//
//  XPInterpreter.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPInterpreter.h"
#import "XPGlobalScope.h"
#import "XPGlobalSpace.h"

#import "XPParser.h"
#import "XPNode.h"

#import "XPTreeWalkerExec.h"
#import <Language/XPUserThrownException.h>

#import <Language/XPObject.h>
#import "XPFunctionSymbol.h"

#import "FNBoolean.h"
#import "FNNumber.h"
#import "FNString.h"
#import "FNType.h"

#import "FNAssert.h"
#import "FNPrint.h"
#import "FNCopy.h"

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
#import "FNRandom.h"
#import "FNAbs.h"
#import "FNRound.h"
#import "FNFloor.h"
#import "FNCeil.h"
#import "FNMax.h"
#import "FNMin.h"
#import "FNSqrt.h"
#import "FNPow.h"
#import "FNLog.h"

#import "FNAcos.h"
#import "FNAsin.h"
#import "FNATan.h"
#import "FNAtan2.h"
#import "FNCos.h"
#import "FNDegrees.h"
#import "FNRadians.h"
#import "FNSin.h"
#import "FNTan.h"

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

@interface XPInterpreter ()
@property (nonatomic, retain) XPTreeWalker *treeWalker;
@property (nonatomic, retain) NSMutableArray *allScopes; // this exists to allow all scopes to persist after parsing until tree traversal is done
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
    self.globals = nil;
    self.root = nil;
    self.parser = nil;
    self.stdOut = nil;
    self.stdErr = nil;
    self.delegate = nil;
    self.breakpointCollection = nil;
    self.debugDelegate = nil;
    
    self.treeWalker = nil;
    self.allScopes = nil;

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
    input = [NSString stringWithFormat:@"%@\n", input]; // ensure final terminator

    self.globalScope = [[[XPGlobalScope alloc] init] autorelease];
    if (!_globals) {
        self.globals = [[[XPGlobalSpace alloc] init] autorelease];       // global memory;
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
        [self declareNativeFunction:[FNPrint class]];
        [self declareNativeFunction:[FNCopy class]];
        
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
        [self declareNativeFunction:[FNRandom class]];
        [self declareNativeFunction:[FNAbs class]];
        [self declareNativeFunction:[FNRound class]];
        [self declareNativeFunction:[FNFloor class]];
        [self declareNativeFunction:[FNCeil class]];
        [self declareNativeFunction:[FNMax class]];
        [self declareNativeFunction:[FNMin class]];
        [self declareNativeFunction:[FNSqrt class]];
        [self declareNativeFunction:[FNPow class]];
        [self declareNativeFunction:[FNLog class]];

        // trig
        [self declareNativeFunction:[FNAcos class]];
        [self declareNativeFunction:[FNAsin class]];
        [self declareNativeFunction:[FNAtan class]];
        [self declareNativeFunction:[FNAtan2 class]];
        [self declareNativeFunction:[FNCos class]];
        [self declareNativeFunction:[FNDegrees class]];
        [self declareNativeFunction:[FNRadians class]];
        [self declareNativeFunction:[FNSin class]];
        [self declareNativeFunction:[FNTan class]];

        if ([_delegate respondsToSelector:@selector(interpreterDidDeclareNativeFunctions:)]) {
            [_delegate interpreterDidDeclareNativeFunctions:self];
        }
    }
    
    // PARSE
    {
        self.allScopes = [NSMutableArray array];

        self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
        _parser.globalScope = _globalScope;
        _parser.globals = _globals;
        _parser.allScopes = _allScopes;
        
        NSError *err = nil;
        PKAssembly *a = [_parser parseString:input error:&err];
        
        if (err) {
            //NSLog(@"%@", err);
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

    @try {
        self.treeWalker = [[[XPTreeWalkerExec alloc] initWithDelegate:self] autorelease];
        _treeWalker.globalScope = _globalScope;
        _treeWalker.globals = _globals;
        _treeWalker.stdOut = _stdOut;
        _treeWalker.stdErr = _stdErr;
        _treeWalker.debug = _debug;
        _treeWalker.breakpointCollection = _breakpointCollection;
        _treeWalker.currentFilePath = path ? path : @"<main>";
        [_treeWalker walk:_root];
    } @catch (XPUserThrownException *rex) {
        success = NO;
        if (outErr) {
            //NSLog(@"%@", rex.reason);
            *outErr = [self errorWithName:rex.name reason:rex.reason range:rex.range lineNumber:rex.lineNumber];
        } else {
            [rex raise];
        }
    } @catch (XPException *ex) {
        success = NO;
        if (outErr) {
            //NSLog(@"%@", ex.reason);
            *outErr = [self errorWithName:ex.name reason:ex.reason range:ex.range lineNumber:ex.lineNumber];
        } else {
            [ex raise];
        }
    } @finally {
        self.treeWalker = nil;
        self.allScopes = nil;
    }
    
    return success;
}


- (NSError *)errorWithName:(NSString *)name reason:(NSString *)reason range:(NSRange)r lineNumber:(NSUInteger)lineNum {
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
    NSString *name = XPSyntaxError; //inErr.localizedDescription;
    NSString *reason = inErr.userInfo[NSLocalizedFailureReasonErrorKey];
    NSRange range = [inErr.userInfo[XPErrorRangeKey] rangeValue];
    NSUInteger lineNum = [inErr.userInfo[XPErrorLineNumberKey] unsignedIntegerValue];

    NSError *outErr = [self errorWithName:name reason:reason range:range lineNumber:lineNum];
    return outErr;
}


- (void)declareNativeFunction:(Class)cls {
    TDAssert([cls isSubclassOfClass:[XPFunctionBody class]]);
    NSString *name = [cls name];
    XPFunctionBody *body = [[[cls alloc] init] autorelease];
    
    XPFunctionSymbol *funcSym = [body symbol];
    
    // declare
    TDAssert(_globalScope);
    [_globalScope defineSymbol:funcSym];
    
    // define in memory
//    XPObject *obj = [XPObject function:funcSym];
//
//    TDAssert(_globals);
//    [_globals setObject:obj forName:name];
    
    [XPSymbol addReservedWord:name];
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

- (void)updateBreakpoints:(XPBreakpointCollection *)bpColl {
    self.breakpointCollection = bpColl;
    _treeWalker.breakpointCollection = bpColl;
}


- (NSArray *)completionsForPrefix:(NSString *)prefix inRange:(NSRange)range {
    return nil;
}


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
    self.treeWalker.wantsPauseOnReturn = YES;
    self.treeWalker.currentSpace.wantsPause = YES;
    [self resume];
}


- (void)stepIn {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    self.treeWalker.wantsPauseOnCall = YES;
    self.treeWalker.wantsPauseOnReturn = YES;
    self.treeWalker.currentSpace.wantsPause = YES;
    [self resume];
}


- (void)cont {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.wantsPauseOnReturn = NO;
    self.treeWalker.currentSpace.wantsPause = NO;
    [self resume];
}


- (void)finish {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_treeWalker);
    TDAssert(_debugDelegate);
    
    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.wantsPauseOnReturn = YES;
    self.treeWalker.currentSpace.wantsPause = NO;
    [self resume];
}


- (void)print:(NSString *)exprStr {
    TDAssertMainThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    
    exprStr = [NSString stringWithFormat:@"var %@=%@;", DEBUG_VAR_NAME, exprStr];
    
    NSError *err = nil;
    [self interpretString:exprStr filePath:nil error:&err];
    
    TDAssert(_globals);
    XPObject *obj = [_globals objectForName:DEBUG_VAR_NAME];
    NSString *res = [NSString stringWithFormat:@"\n%@\n", [obj stringValue]];
    
    TDAssert(_stdOut);
    [_stdOut writeData:[res dataUsingEncoding:NSUTF8StringEncoding]];

}

//- (id)evaluateString:(NSString *)script error:(NSError **)outErr {
//
//    XPInterpreter *interp = [[[XPInterpreter alloc] init] autorelease];
//    
//    TDAssert(_treeWalker);
//    NSMutableDictionary<NSString *, XPObject *> *mems = [[[_globals members] mutableCopy] autorelease];
//    [mems addEntriesFromDictionary:_treeWalker.currentSpace.members];
//    
//    XPMemorySpace *monoSpace = [[[XPGlobalSpace alloc] init] autorelease];
//    [monoSpace addMembers:_globals.members];
//    
//    for (XPMemorySpace *space in [_treeWalker.callStack reverseObjectEnumerator]) {
//        [monoSpace addMembers:space.members];
//    }
//    
//    interp.globals = monoSpace;
//    
//    NSError *err = nil;
//    if (![interp interpretString:script filePath:nil error:&err]) {
//        TDAssert(err);
//        //NSLog(@"%@", err);
//        return nil;
//    }
//    
//    return interp.globals; // TODO
//}

@end
