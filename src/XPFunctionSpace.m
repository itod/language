//
//  XPFunctionSpace.m
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionSpace.h"
#import "XPSymbol.h"

@implementation XPFunctionSpace

- (instancetype)initWithSymbol:(XPSymbol *)sym {
    self = [super initWithName:sym.name enclosingSpace:nil];
    if (self) {
        
    }
    return self;
}

@end
