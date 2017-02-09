//
//  XPObject.h
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPClass;

@interface XPObject : NSObject

+ (instancetype)null;
+ (instancetype)objectWithClass:(XPClass *)cls value:(id)val;

- (id)callInstanceMethodNamed:(NSString *)name withArg:(id)arg; // convenience
- (id)callInstanceMethodNamed:(NSString *)name args:(NSArray *)args;

@property (nonatomic, retain, readonly) XPClass *class;
@property (nonatomic, retain, readonly) id value;
@end
