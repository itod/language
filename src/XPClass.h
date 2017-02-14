//
//  XPClass.h
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;
@class XPEnumeration;

@interface XPClass : NSObject

+ (instancetype)classInstance;
+ (XPObject *)instanceWithValue:(id)val;

- (NSString *)name;

- (XPObject *)internedObjectWithValue:(id)val;
- (NSMethodSignature *)getInvocation:(NSInvocation **)outInvoc forMethodNamed:(NSString *)methName;

- (XPEnumeration *)enumeration:(XPObject *)this;

// Subclass
- (SEL)selectorForMethodNamed:(NSString *)methName;
@end
