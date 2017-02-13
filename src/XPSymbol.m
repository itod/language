//
//  XPSymbol.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPSymbol.h"
#import "XPScope.h"

static NSSet *sReserved = nil;

@implementation XPSymbol

+ (void)initialize {
    if ([XPSymbol class] == self) {
        sReserved = [[NSSet alloc] initWithObjects:
          @"for",
          @"in",
          @"while",
          @"if",
          @"else",
          @"break",
          @"continue",
          @"return",
          @"and",
          @"or",
          @"not",
          @"true",
          @"false",
          @"null",
          @"boolean",
          @"number",
          @"string",
          @"array",
          @"table",
          @"sub",
          @"var",
        nil];
    }
}


+ (NSSet *)reservedWords {
    return sReserved;
}


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
