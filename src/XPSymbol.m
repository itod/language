//
//  XPSymbol.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPSymbol.h"
#import "XPScope.h"

static NSMutableSet *sReserved = nil;

@implementation XPSymbol

+ (void)initialize {
    if ([XPSymbol class] == self) {
        sReserved = [[NSMutableSet alloc] initWithObjects:
                     @"synchronized",
                     @"await",
                     @"import",
                     @"switch",
                     @"case",
                     @"default",
                     @"for",
                     @"in",
                     @"is",
                     @"while",
                     @"do",
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
                     @"NaN",
                     
                     @"sub",
                     @"var",
                     @"const",
                     
                     @"new",
                     @"class",
                     @"extends",
                     @"implements",
                     @"static",
                     @"interface",
                     @"public",
                     @"private",
                     @"abstract",
                     @"this",
                     @"super",
                     
                     @"throws",
                     @"throw",
                     @"try",
                     @"catch",
                     @"finally",
                     
                     @"Object",
//                     @"Boolean",
//                     @"Number",
//                     @"String",
                     @"Array",
                     @"Dictionary",
                     @"void",
                     
                     nil];
    }
}


+ (NSSet *)reservedWords {
    return sReserved;
}


+ (void)addReservedWord:(NSString *)s {
    TDAssert(![sReserved containsObject:s])
    [sReserved addObject:s];
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
    TDAssert(self.scope.scopeName);
    return [NSString stringWithFormat:@"%@.%@", self.scope.scopeName, self.name];
}

@end
