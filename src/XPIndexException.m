//
//  XPIndexException.m
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPIndexException.h>

@implementation XPIndexException

- (instancetype)initWithIndex:(NSInteger)index first:(NSInteger)first last:(NSInteger)last; {
    self = [super initWithName:XPIndexError reason:nil userInfo:nil];
    if (self) {
        self.index = index;
        self.first = first;
        self.last = last;
    }
    return self;
}

@end
