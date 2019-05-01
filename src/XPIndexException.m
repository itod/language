//
//  XPIndexException.m
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPIndexException.h"

@implementation XPIndexException

- (instancetype)initWithIndex:(NSInteger)index first:(NSInteger)first last:(NSInteger)last; {
    NSString *reason = [NSString stringWithFormat:@"Index `%ld` out of range `%ld–%ld`.", index, first, last];
    self = [super initWithName:XPIndexError reason:reason userInfo:nil];
    if (self) {
        self.index = index;
        self.first = first;
        self.last = last;
    }
    return self;
}

@end
