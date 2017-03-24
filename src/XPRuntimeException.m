//
//  XPRuntimeException.m
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPRuntimeException.h"

@implementation XPRuntimeException

- (void)dealloc {
    self.thrownObject = nil;
    [super dealloc];
}

@end
