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

#import <PEGKit/PKAssembly.h>
#import <Language/XPContext.h>

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
        XPTreeWalker *walker = [[[XPTreeWalkerEval alloc] init] autorelease];
        walker.globals = _globals;
        walker.currentSpace = _globals;
        [walker walk:_root];
    }
}

@end
