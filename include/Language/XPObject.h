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
@class XPFunctionSymbol;

@interface XPObject : NSObject <NSCopying>

+ (instancetype)nullObject;
+ (instancetype)nanObject;
+ (instancetype)trueObject;
+ (instancetype)falseObject;
+ (instancetype)boolean:(BOOL)b;
+ (instancetype)number:(double)n;
+ (instancetype)string:(NSString *)s;
+ (instancetype)array:(NSArray *)v;
+ (instancetype)dictionary:(NSDictionary *)d;
+ (instancetype)function:(XPFunctionSymbol *)funcSym;
+ (instancetype)objectWithClass:(XPClass *)cls value:(id)val;

- (id)callInstanceMethodNamed:(NSString *)name; // convenience
- (id)callInstanceMethodNamed:(NSString *)name withArg:(id)arg; // convenience
- (id)callInstanceMethodNamed:(NSString *)name withArgs:(NSArray *)args;

- (BOOL)isEqualToObject:(XPObject *)other;
- (BOOL)isNotEqualToObject:(XPObject *)other;

- (BOOL)compareToObject:(XPObject *)other usingOperator:(NSInteger)op;

- (NSString *)reprValue;
- (NSString *)stringValue;
- (double)doubleValue;
- (BOOL)boolValue;

- (XPObject *)asBooleanObject;
- (XPObject *)asNumberObject;
- (XPObject *)asStringObject;

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
@property (nonatomic, assign, readonly) BOOL isNative;
@end
