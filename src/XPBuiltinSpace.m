//
//  XPBuiltinSpace.m
//  Language
//
//  Created by Todd Ditchendorf on 3/27/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBuiltinSpace.h"

@implementation XPBuiltinSpace

- (instancetype)initWithEnclosingSpace:(XPMemorySpace *)space {
    TDAssert(0);
    return nil;
}


- (instancetype)init {
    self = [super initWithName:@"<builtin>" enclosingSpace:nil];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    TDAssert(!self.enclosingSpace);
    [super dealloc];
}

@end
