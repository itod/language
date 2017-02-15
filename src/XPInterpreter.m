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

#import "XPFunctionClass.h"
#import "XPFunctionSymbol.h"

#import "FNBoolean.h"
#import "FNNumber.h"
#import "FNString.h"

#import "FNAssert.h"
#import "FNCount.h"
#import "FNPrint.h"
#import "FNRange.h"
#import "FNType.h"

#import "FNTrim.h"
#import "FNLowercase.h"
#import "FNUppercase.h"

#import <PEGKit/PKAssembly.h>

NSString * const XPErrorDomain = @"XPErrorDomain";
NSString * const XPErrorRangeKey = @"range";
NSString * const XPErrorLineNumberKey = @"line number";

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

    [super dealloc];
}



- (void)interpretString:(NSString *)input error:(NSError **)outErr {
    self.globalScope = [[[XPGlobalScope alloc] init] autorelease];
    self.globals = [[[XPMemorySpace alloc] initWithName:@"globals"] autorelease];       // global memory;
    
    // DECLARE NATIVE FUNCS
    {
        [self declareNativeFunction:[FNBoolean class]];
        [self declareNativeFunction:[FNNumber class]];
        [self declareNativeFunction:[FNString class]];
        
        [self declareNativeFunction:[FNAssert class]];
        [self declareNativeFunction:[FNCount class]];
        [self declareNativeFunction:[FNPrint class]];
        [self declareNativeFunction:[FNRange class]];
        [self declareNativeFunction:[FNType class]];

        [self declareNativeFunction:[FNTrim class]];
        [self declareNativeFunction:[FNLowercase class]];
        [self declareNativeFunction:[FNUppercase class]];
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
            return;
        }
        TDAssert(!(*outErr));
        
        self.root = [a pop];
        
        if (!_root) {
            *outErr = err;
            return;
        }
    }
    
    // EVAL WALK
    {
        @try {
            XPTreeWalker *walker = [[[XPTreeWalkerExec alloc] init] autorelease];
            walker.globals = _globals;
            [walker walk:_root];
        } @catch (XPException *ex) {
            if (outErr) {
                NSString *domain = XPErrorDomain;
                NSString *name = [ex name];
                NSString *reason = [ex reason];
                NSLog(@"%@", reason);
                
                *outErr = [self errorWithDomain:domain name:name reason:reason range:ex.range lineNumber:ex.lineNumber];
            } else {
                [ex raise];
            }
        }
    }
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
    TDAssert(_globals);
    [_globals setObject:obj forName:name];
}

@end
