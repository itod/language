//
//  XPFunctionSymbol.h
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScopedSymbol.h"

@class XPNode;
@class XPFunctionBody;

@interface XPFunctionSymbol : XPScopedSymbol

+ (instancetype)symbolWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;
- (instancetype)initWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;

- (void)setDefaultValue:(XPNode *)val forParamNamed:(NSString *)name;

@property (nonatomic, retain) XPNode *blockNode;
@property (nonatomic, retain) XPFunctionBody *nativeBody;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *params;
@property (nonatomic, retain) NSMutableArray<XPSymbol *> *orderedParams;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPNode *> *defaultParamValues;
@end
