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
    self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
    _parser.globalScope = _globalScope;
    
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
    
    // EVAL WALK
    @try {
        XPTreeWalker *walker = [[[XPTreeWalkerExec alloc] init] autorelease];
        [walker walk:_root];
        self.globals = walker.globals;
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

@end
