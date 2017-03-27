//
//  XPLocalSpace.h
//  Language
//
//  Created by Todd Ditchendorf on 3/27/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPMemorySpace.h"

@interface XPLocalSpace : XPMemorySpace
- (instancetype)initWithEnclosingSpace:(XPMemorySpace *)space;
@end
