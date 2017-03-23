//
//  XPGlobalScope.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPGlobalScope.h"

@implementation XPGlobalScope

// - (instancetype)initWithEnclosingScope:(id <XPScope>)scope {
//     self = [super initWithEnclosingScope:scope];
//     if (self) {
//     }
//     return self;
// }
//
//
// - (void)dealloc {
//     [super dealloc];
// }


#pragma mark -
#pragma mark XPScope

- (NSString *)scopeName {
    return @"global";
}

@end
