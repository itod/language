//
//  XPFunctionSpace.h
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPMemorySpace.h"

@class XPSymbol;

@interface XPFunctionSpace : XPMemorySpace
+ (instancetype)functionSpaceWithSymbol:(XPSymbol *)sym;
- (instancetype)initWithSymbol:(XPSymbol *)sym;
@end
