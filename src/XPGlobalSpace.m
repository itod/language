//
//  XPGlobalSpace.m
//  Language
//
//  Created by Todd Ditchendorf on 3/27/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPGlobalSpace.h"

@implementation XPGlobalSpace

- (instancetype)init {
    self = [super initWithName:@"global" enclosingSpace:nil];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    TDAssert(!self.enclosingSpace);
    [super dealloc];
}

@end
