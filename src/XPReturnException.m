//
//  XPReturnException.m
//  Language
//
//  Created by Todd Ditchendorf on 2/15/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPReturnException.h"

@implementation XPReturnExpception

- (void)dealloc {
    self.value = nil;
    [super dealloc];
}

@end

@implementation XPBreakException
@end

@implementation XPContinueException
@end

@implementation XPThrownException
@end
