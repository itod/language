//
//  XPLocalSpace.m
//  Language
//
//  Created by Todd Ditchendorf on 3/27/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPLocalSpace.h"

@implementation XPLocalSpace

- (instancetype)initWithEnclosingSpace:(XPMemorySpace *)space {
    self = [super initWithName:@"local" enclosingSpace:space];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    TDAssert(self.enclosingSpace);
    [super dealloc];
}

@end
