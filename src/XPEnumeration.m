//
//  XPEnumerator.m
//  Language
//
//  Created by Todd Ditchendorf on 2/12/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPEnumeration.h"

@implementation XPEnumeration

+ (instancetype)enumerationWithValues:(NSArray *)vals {
    return [[[self alloc] initWithValues:vals] autorelease];
}


- (instancetype)initWithValues:(NSArray *)vals {
    self = [super init];
    if (self) {
        self.values = vals;
    }
    return self;
}


- (void)dealloc {
    self.values = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p %ld>", [self class], self, _current];
}

- (BOOL)hasMore {
    return _current < [_values count];
}

@end
