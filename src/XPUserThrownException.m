//
//  XPUserThrownException.m
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPUserThrownException.h>

@implementation XPUserThrownException

- (instancetype)initWithThrownObject:(XPObject *)obj {
    self = [super initWithName:@"" reason:@"" userInfo:nil];
    if (self) {
        self.thrownObject = obj;
    }
    return self;
}


- (void)dealloc {
    self.thrownObject = nil;
    [super dealloc];
}

@end
