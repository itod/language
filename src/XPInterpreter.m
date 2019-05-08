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
#import "FNArray.h"
#import "FNDictionary.h"
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
#import "FNSum.h"
#import "FNSort.h"
#import "FNMap.h"
#import "FNFilter.h"
#import "FNLocals.h"
#import "FNGlobals.h"

#if COLLECTION_FUNCS
#import "FNReverse.h"
#import "FNAppend.h"
#import "FNExtend.h"
#import "FNInsert.h"
#import "FNHasKey.h"
#import "FNRemoveKey.h"
#endif

#import "FNOrd.h"
#import "FNChr.h"
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

#define DOCS 1

NSString * const XPErrorDomain = @"XPErrorDomain";
NSString * const XPErrorRangeKey = @"range";
NSString * const XPErrorLineNumberKey = @"lineNumber";

NSString * const XPDebugInfoErrorKey = @"error";
NSString * const XPDebugInfoReturnCodeKey = @"returnCode";
NSString * const XPDebugInfoFrameStackKey = @"frameStack";
NSString * const XPDebugInfoFilePathKey = @"filePath";
NSString * const XPDebugInfoLineNumberKey = @"lineNumber";

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
            [self declareNativeFunction:[FNArray class]];
            [self declareNativeFunction:[FNDictionary class]];
            [self declareNativeFunction:[FNType class]];
            
            // util
            [self declareNativeFunction:[FNRepr class]];
            [self declareNativeFunction:[FNPrint class]];
            [self declareNativeFunction:[FNAssert class]];
            [self declareNativeFunction:[FNCopy class]];
            [self declareNativeFunction:[FNDescription class]];
            [self declareNativeFunction:[FNSleep class]];
            [self declareNativeFunction:[FNExit class]];
            [self declareNativeFunction:[FNLocals class]];
            [self declareNativeFunction:[FNGlobals class]];

            // seq
            [self declareNativeFunction:[FNCount class]];
            [self declareNativeFunction:[FNPosition class]];

            // arr
            [self declareNativeFunction:[FNRange class]];
            [self declareNativeFunction:[FNSum class]];
            [self declareNativeFunction:[FNSort class]];
            [self declareNativeFunction:[FNMap class]];
            [self declareNativeFunction:[FNFilter class]];

#if COLLECTION_FUNCS
            [self declareNativeFunction:[FNReverse class]];
            [self declareNativeFunction:[FNAppend class]];
            [self declareNativeFunction:[FNExtend class]];
            [self declareNativeFunction:[FNInsert class]];
            [self declareNativeFunction:[FNHasKey class]];
            [self declareNativeFunction:[FNRemoveKey class]];
#endif
            
            // str
            [self declareNativeFunction:[FNOrd class]];
            [self declareNativeFunction:[FNChr class]];
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
//            [self declareNativeFunction:[FNPow class]];
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
#if DOCS
    [self produceDocumentation];
#endif
    
    // PARSE
    XPNode *root = [self parseInput:input error:outErr];
    if (!root) {
        return nil;
    }

    // EVAL WALK
    return [self eval:root filePath:path error:outErr];
}


- (XPNode *)parseInput:(NSString *)input error:(NSError **)outErr {
    input = [NSString stringWithFormat:@"%@\n", input]; // ensure final terminator

    self.allScopes = [NSMutableArray array];
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


- (id)eval:(XPNode *)root filePath:(NSString *)path error:(NSError **)outErr {
    id result = nil;
    
    self.root = root;
    _globals.wantsPause = NO; // reset pause state for looping like draw()
    
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

    return result;
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

    XPMemorySpace *builtins = _globals.enclosingSpace;
    TDAssert(builtins);
    [builtins setObject:obj forName:name];
    
    [XPSymbol addReservedWord:name];
}


- (void)declareNativeVariable:(XPObject *)obj forName:(NSString *)name {
    XPMemorySpace *builtins = _globals.enclosingSpace;
    TDAssert(builtins);
    [builtins setObject:obj forName:name];

    [XPSymbol addReservedWord:name];
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
    self.treeWalker.debug = nil != bpColl;
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
    
    if (err) {
        result = nil;
        goto done;
    }
    
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
        if (err) {
            result = nil;
            goto done;
        }
        
        result = [obj reprValue];
    }
    
done:
    if (!result) {
        if (err) result = [err localizedFailureReason];
        else result = @"Unknown Error.";
    }

    result = [NSString stringWithFormat:@"\n%@\n", result];

    TDAssert(_stdOut);
    [_stdOut writeData:[result dataUsingEncoding:NSUTF8StringEncoding]];
}


#if DOCS
- (void)produceDocumentation {
    NSMutableArray *funcs = [NSMutableArray array];
    //    NSDictionary *mems = _globals.enclosingSpace.members;
    NSDictionary *symTab = _globalScope.symbols;
    NSArray *names = [[symTab allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString *name in names) {
        XPFunctionSymbol *funcSym = [symTab objectForKey:name];
        id func = [NSMutableDictionary dictionary];
        [funcs addObject:func];

        [func setObject:name forKey:@"name"];
        NSLog(@"                <li><a href=\"#fn-%@\">%@()</a></li>", name, name);
        NSString *retType = [funcSym.returnType name]; //[ stringByReplacingOccurrencesOfString:@"null" withString:@"Void"];
        if (!retType) {
            retType = @"Void";
        }
        [func setObject:retType forKey:@"returnType"];
        [func setObject:@"baz" forKey:@"desc"];
        id params = [NSMutableArray array];
        for (XPFunctionSymbol *paramSym in funcSym.orderedParams) {
            id param = [NSMutableDictionary dictionary];
            [params addObject:param];
            [param setObject:paramSym.name forKey:@"name"];
            [param setObject:@"foo" forKey:@"type"];
            BOOL optional = nil != [funcSym.defaultParamObjects objectForKey:paramSym.name];
            [param setObject:@(optional) forKey:@"optional"];
        }
        [func setObject:params forKey:@"params"];
    }

    id eng = [[[NSClassFromString(@"TDTemplateEngine") alloc] init] autorelease];
    NSString *tempFilePath = [@"~/work/github/language/res/doc.html.tmpl" stringByExpandingTildeInPath];
    NSString *tempStr = [NSString stringWithContentsOfFile:tempFilePath encoding:NSUTF8StringEncoding error:nil];
    id vars = @{@"funcs": funcs};

    NSString *res = [self processTemplate:tempStr withEngine:eng variables:vars];
    NSString *destFilePath = [@"~/Desktop/doc.html" stringByExpandingTildeInPath];
    [res writeToFile:destFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}


- (NSString *)processTemplate:(NSString *)tempStr withEngine:(id)eng variables:(NSDictionary *)vars {
    NSOutputStream *output = [NSOutputStream outputStreamToMemory];

    NSError *err = nil;
    [eng processTemplateString:tempStr withVariables:vars toStream:output error:&err];

    NSString *result = [[[NSString alloc] initWithData:[output propertyForKey:NSStreamDataWrittenToMemoryStreamKey] encoding:NSUTF8StringEncoding] autorelease];

    NSAssert([result length], @"");
    return result;
}
#endif

#pragma mark -
#pragma mark Properties

- (XPTreeWalker *)treeWalker {
    return [_treeWalkerStack lastObject];
}

@end
