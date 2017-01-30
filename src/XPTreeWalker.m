//
//  XPTreeWalker.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalker.h"

@implementation XPTreeWalker

- (void)dealloc {
    self.globalScope = nil;
    self.globals = nil;
    self.currentSpace = nil;
    
    [super dealloc];
}


- (void)walk:(XPNode *)root {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
}

@end
