//
//  XPFunctionBody.h
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;
@class XPFunctionSymbol;
@class XPTreeWalker;

@interface XPFunctionBody : NSObject
+ (NSString *)name;
- (XPFunctionSymbol *)symbol;
- (XPObject *)callWithWalker:(XPTreeWalker *)walker;
@end
