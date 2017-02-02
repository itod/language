//
//  XPFunctionSpace.m
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionSpace.h"

@implementation XPFunctionSpace

+ (instancetype)spaceWithSymbol:(XPSymbol *)sym {
    return [[[self alloc] initWithSymbol:sym] autorelease];
}


- (instancetype)initWithSymbol:(XPSymbol *)sym {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)dealloc {
    
    [super dealloc];
}

@end
