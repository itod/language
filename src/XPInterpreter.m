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

#import "FNRepr.h"
#import "FNPrint.h"
#import "FNAssert.h"
#import "FNCopy.h"
#import "FNDescription.h"
#import "FNSleep.h"
#import "FNExit.h"

#import "FNPosition.h"
#import "FNRange.h"

#import "FNCount.h"
#import "FNContains.h"
#import "FNRemove.h"
#import "FNSum.h"
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
#import "FNAtan.h"
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

@interface XPObject ()
@property (nonatomic, assign, readwrite) BOOL isNative;
@end

@interface XPInterpreter ()
@property (nonatomic, retain) NSMutableArray *treeWalkerStack;
@property (nonatomic, retain, readonly) XPTreeWalker *treeWalker;
@property (nonatomic, retain) NSMutableArray *allScopes; // this exists to allow all scopes to persist after parsing until tree traversal is done
@end

@implementation XPInterpreter

- (instancetype)init {
    self = [self initWithDelegate:nil];
    return self;
}


- (instancetype)initWithDelegate:(id <XPInterpreterDelegate>)d {
    self = [super init];
    if (self) {
        self.delegate = d;
        self.treeWalkerStack = [NSMutableArray array];
        
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
            [self declareNativeFunction:[FNRepr class]];
            [self declareNativeFunction:[FNPrint class]];
            [self declareNativeFunction:[FNAssert class]];
            [self declareNativeFunction:[FNCopy class]];
            [self declareNativeFunction:[FNDescription class]];
            [self declareNativeFunction:[FNSleep class]];
            [self declareNativeFunction:[FNExit class]];

            // seq
            [self declareNativeFunction:[FNCount class]];
            [self declareNativeFunction:[FNPosition class]];
            [self declareNativeFunction:[FNRange class]];
            [self declareNativeFunction:[FNSum class]];

            // coll
            [self declareNativeFunction:[FNContains class]];
            [self declareNativeFunction:[FNRemove class]];
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
    
    self.treeWalkerStack = nil;
    self.allScopes = nil;

    [super dealloc];
}


- (id)interpretFileAtPath:(NSString *)path error:(NSError **)outErr {
    TDAssert([path length]);
    
    NSError *err = nil;
    NSString *src = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    if (!src) {
        if (outErr) *outErr = err;
        return nil;
    }
    
    return [self interpretString:src filePath:path error:outErr];
}


- (id)interpretString:(NSString *)input filePath:(NSString *)path error:(NSError **)outErr {
    id result = nil;

    input = [NSString stringWithFormat:@"%@\n", input]; // ensure final terminator
    
    // PARSE
    {
        self.allScopes = [NSMutableArray array];
        
        self.root = [self parseInput:input error:outErr];
        if (!_root) {
            return nil;
        }
    }
    
    // EVAL WALK
    {
        XPTreeWalker *walker = [[[XPTreeWalkerExec alloc] initWithDelegate:self] autorelease];
        walker.globalScope = _globalScope;
        walker.globals = _globals;
        walker.stdOut = _stdOut;
        walker.stdErr = _stdErr;
        walker.debug = _debug;
        walker.breakpointCollection = _breakpointCollection;
        if (path) walker.currentFilePath = path;
        
        TDAssert(_treeWalkerStack);
        [_treeWalkerStack addObject:walker];
        
        @try {
            result = [self walk:_root with:walker error:outErr];
        } @finally {
            TDAssert([_treeWalkerStack count]);
            [_treeWalkerStack removeLastObject];
            self.allScopes = nil;
        }
    }
    
    return result;
}


- (XPNode *)parseInput:(NSString *)input error:(NSError **)outErr {
    self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
    _parser.globalScope = _globalScope;
    _parser.globals = _globals;
    _parser.allScopes = _allScopes;
    
    NSError *err = nil;
    PKAssembly *a = [_parser parseString:input error:&err];
    
    if (err) {
        //NSLog(@"%@", err);
        if (outErr) {
            *outErr = [self errorFromPEGKitError:err];
        }
        return nil;
    }
    TDAssert(!(*outErr));
    
    XPNode *root = [[[a pop] retain] autorelease];
    
    self.parser = nil;

    if (!root) {
        *outErr = err;
    }
    
    return root;
}


- (id)walk:(XPNode *)node with:(XPTreeWalker *)walker error:(NSError **)outErr {
    id result = nil;
    
    @try {
        result = [walker walk:node];
        if (!result) {
            result = [NSNull null];
        }
    } @catch (XPException *ex) {
        result = nil;
        if (outErr) {
            //NSLog(@"%@", ex.reason);
            *outErr = [self errorWithName:ex.name reason:ex.reason range:ex.range lineNumber:ex.lineNumber];
        } else {
            [ex raise];
        }
    }

    return result;
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
    XPObject *obj = [XPObject function:funcSym];
    obj.isNative = YES;

    TDAssert(_globals);
    [_globals setObject:obj forName:name];
    
    [XPSymbol addReservedWord:name];
}


- (void)declareNativeVariable:(XPObject *)obj forName:(NSString *)name {
    obj.isNative = YES;
    [self.globals setObject:obj forName:name];
}


#pragma mark -
#pragma mark XPTreeWalkerDelegate

- (void)treeWalker:(XPTreeWalker *)w didPause:(NSMutableDictionary *)debugInfo {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(w == self.treeWalker);

    TDAssert(_debugDelegate);
    [_debugDelegate interpreter:self didPause:debugInfo];
}


- (BOOL)shouldPauseForTreeWalker:(XPTreeWalker *)w {
    BOOL yn = self.paused;
    if (yn) {
        self.paused = NO;
    }
    return yn;
}


#pragma mark -
#pragma mark DEBUG

- (void)updateBreakpoints:(XPBreakpointCollection *)bpColl {
    self.breakpointCollection = bpColl;
    self.treeWalker.breakpointCollection = bpColl;
}


- (NSArray *)completionsForPrefix:(NSString *)prefix inRange:(NSRange)range {
    return nil;
}


- (void)pause {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    TDAssert(self.treeWalker);
    
    [self stepIn];
}


- (void)resume {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    TDAssert(self.treeWalker);

    return; // noop resumes
}


- (void)stepOver {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    TDAssert(self.treeWalker);

    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.wantsPauseOnReturn = YES;
    self.treeWalker.currentSpace.wantsPause = YES;
    [self resume];
}


- (void)stepIn {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    TDAssert(self.treeWalker);
    
    self.treeWalker.wantsPauseOnCall = YES;
    self.treeWalker.wantsPauseOnReturn = YES;
    self.treeWalker.currentSpace.wantsPause = YES;
    [self resume];
}


- (void)cont {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    TDAssert(self.treeWalker);
    
    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.wantsPauseOnReturn = NO;
    self.treeWalker.currentSpace.wantsPause = NO;
    [self resume];
}


- (void)finish {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    TDAssert(self.treeWalker);
    
    self.treeWalker.wantsPauseOnCall = NO;
    self.treeWalker.wantsPauseOnReturn = YES;
    self.treeWalker.currentSpace.wantsPause = NO;
    [self resume];
}


- (void)print:(NSString *)exprStr {
    TDAssertExecuteThread();
    TDAssert(_debug);
    TDAssert(_debugDelegate);
    
    exprStr = [NSString stringWithFormat:@"(%@)", exprStr];

    NSString *result = nil;
    
    NSError *err = nil;
    XPNode *node = [self parseInput:exprStr error:&err];
    
    if (node) {
        TDAssert(!err);
        
        err = nil;
        
        // peel off BLOCK (that causes an eroneous local space to be created that clobbers the closure's surrounding scope - ie, where we paused)
        TDAssert([@"BLOCK" isEqualToString:node.name]);
        node = [node.children firstObject];
        TDAssert(![@"BLOCK" isEqualToString:node.name]);
        
        XPTreeWalker *walker = [[[XPTreeWalkerExec alloc] initWithDelegate:self] autorelease];
        walker.globalScope = [[_globalScope copy] autorelease];
        walker.globals = [[_globals copy] autorelease];
        walker.currentSpace = [[self.treeWalker.currentSpace copy] autorelease];
        walker.debug = NO;

        TDAssert(_treeWalkerStack);
        [_treeWalkerStack addObject:walker];

        XPObject *obj = [self walk:node with:walker error:&err];
        result = [NSString stringWithFormat:@"\n%@\n", [obj description]];
    }
    
    if (!result) {
        if (err) result = [err description];
        else result = @"Unknown Error.";
    }

    TDAssert(_stdOut);
    [_stdOut writeData:[result dataUsingEncoding:NSUTF8StringEncoding]];

}


#pragma mark -
#pragma mark Properties

- (XPTreeWalker *)treeWalker {
    return [_treeWalkerStack lastObject];
}

@end
