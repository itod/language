//
//  XPObject.h
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPClass;
@class XPEnumeration;

@interface XPObject : NSObject <NSCopying>

+ (instancetype)null;
+ (instancetype)nan;
+ (instancetype)objectWithClass:(XPClass *)cls value:(id)val;

- (id)callInstanceMethodNamed:(NSString *)name; // convenience
- (id)callInstanceMethodNamed:(NSString *)name withArg:(id)arg; // convenience
- (id)callInstanceMethodNamed:(NSString *)name args:(NSArray *)args;

- (BOOL)isEqualToObject:(XPObject *)other;
- (BOOL)isNotEqualToObject:(XPObject *)other;

- (BOOL)compareToObject:(XPObject *)other usingOperator:(NSInteger)op;

- (NSString *)stringValue;
- (double)doubleValue;
- (BOOL)boolValue;

- (BOOL)isBooleanObject;
- (BOOL)isNumericObject;
- (BOOL)isStringObject;
- (BOOL)isFunctionObject;
- (BOOL)isArrayObject;
- (BOOL)isDictionaryObject;

- (NSUInteger)hash;
- (XPEnumeration *)enumeration;

@property (nonatomic, retain, readonly) XPClass *objectClass;
@property (nonatomic, retain, readonly) id value;
@end
