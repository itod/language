//
//  XPSymbol.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPSymbol.h"
#import "XPScope.h"

@implementation XPSymbol

+ (instancetype)symbolWithName:(NSString *)name {
    return [[[self alloc] initWithName:name] autorelease];
}


- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}


- (void)dealloc {
    self.name = nil;
    self.scope = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@.%@>", self.scope.scopeName, self.name];
}

@end
