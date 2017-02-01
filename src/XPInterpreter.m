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
#import "XPTreeWalkerEval.h"
#import "XPException.h"

#import <PEGKit/PKAssembly.h>
#import <Language/XPContext.h>

NSString * const XPErrorDomain = @"XPErrorDomain";
NSString * const XPErrorRangeKey = @"range";
NSString * const XPErrorLineNumberKey = @"line number";

@implementation XPInterpreter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.globals = [[[XPMemorySpace alloc] initWithName:@"globals"] autorelease];       // global memory
    }
    return self;
}


- (void)dealloc {
    self.globalScope = nil;
    self.globals = nil;
    self.root = nil;
    self.parser = nil;

    [super dealloc];
}



- (void)interpretString:(NSString *)input error:(NSError **)outErr {
    self.globalScope = [[[XPGlobalScope alloc] init] autorelease];
    self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
    
    NSError *err = nil;
    PKAssembly *a = [_parser parseString:input error:&err];
    TDAssert(a);

    self.root = [a pop];
    
    if (!_root) {
        *outErr = err;
        return;
    }
    
    TDAssert(_globals);
    
    // EVAL WALK
    @autoreleasepool {
        @try {
            XPTreeWalker *walker = [[[XPTreeWalkerEval alloc] init] autorelease];
            walker.globals = _globals;
            walker.currentSpace = _globals;
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
    [userInfo setObject:name forKey:NSLocalizedDescriptionKey];
    
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


@end
