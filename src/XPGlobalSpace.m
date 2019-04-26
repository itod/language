//
//  XPGlobalSpace.m
//  Language
//
//  Created by Todd Ditchendorf on 3/27/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPGlobalSpace.h"
#import "XPBuiltinSpace.h"

@implementation XPGlobalSpace

- (instancetype)init {
    XPMemorySpace *builtins = [[[XPBuiltinSpace alloc] init] autorelease];
    self = [super initWithName:@"<global>" enclosingSpace:builtins];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    TDAssert([self.enclosingSpace isKindOfClass:[XPBuiltinSpace class]]);
    [super dealloc];
}


- (XPMemorySpace *)debugEnclosingSpace {
    return nil;
}


- (NSMutableDictionary *)allMembers {
    return self.members;
}

@end
