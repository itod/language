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
#import "XPNode.h"
#import "XPParser.h"

@implementation XPInterpreter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.globals = [[[XPMemorySpace alloc] initWithName:@"globals"] autorelease];       // global memory
        self.currentSpace = _globals;
    }
    return self;
}


- (void)interpretString:(NSString *)input error:(NSError **)outErr {
    self.globalScope = [[[XPGlobalScope alloc] init] autorelease];
    self.parser = [[[XPParser alloc] initWithDelegate:nil] autorelease];
    
    NSError *err = nil;
    self.root = [_parser parseString:input error:&err];
    
    if (!_root) {
        *outErr = err;
        return;
    }

    [self block:_root];
}


- (void)block:(XPNode *)node {
//    TDAssert(node.tokenType == BLOCK);
    
    
    
}

@end
