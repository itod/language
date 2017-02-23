//
//  XPStackFrame.m
//  Language
//
//  Created by Todd Ditchendorf on 2/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStackFrame.h"

@implementation XPStackFrame

- (void)dealloc {
    self.filename = nil;
    self.functionName = nil;
    self.locals = nil;
    [super dealloc];
}

@end
