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

@interface XPFunctionBody : NSObject
+ (NSString *)name;
- (XPFunctionSymbol *)symbol;
- (XPObject *)call;
@end
