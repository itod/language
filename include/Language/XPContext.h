//
//  XPContext.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScope.h"

@class XPNode;

@protocol XPContext <XPScope>

- (id)loadVariableReference:(XPNode *)node;

@end
