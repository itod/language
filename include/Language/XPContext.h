//
//  XPContext.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPNode;

@protocol XPContext <NSObject>

- (id)loadVariableReference:(XPNode *)node;
- (id)walk:(XPNode *)node;

@end
