//
//  XPFunctionSymbol.h
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScopedSymbol.h"

@class XPNode;
@class XPObject;
@class XPTreeWalker;
@class XPFunctionBody;
@class XPMemorySpace;

@interface XPFunctionSymbol : XPScopedSymbol

+ (instancetype)symbolWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;
- (instancetype)initWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;

- (void)setDefaultExpression:(XPNode *)val forParamNamed:(NSString *)name;
- (void)setDefaultObject:(XPObject *)obj forParamNamed:(NSString *)name;

@property (nonatomic, assign) XPObject *provisionalObject; // weakref
@property (nonatomic, retain) XPNode *blockNode;
@property (nonatomic, retain) XPFunctionBody *nativeBody;
@property (nonatomic, retain) XPMemorySpace *closureSpace;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *params;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *members;
@property (nonatomic, retain) NSMutableArray<XPSymbol *> *orderedParams;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPNode *> *defaultParamExpressions;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPObject *> *defaultParamObjects;
@end
