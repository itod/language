//
//  XPFunctionSymbol.h
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScopedSymbol.h"

@class XPNode;
@class XPExpression;

@interface XPFunctionSymbol : XPScopedSymbol

+ (instancetype)symbolWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;
- (instancetype)initWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;

- (void)setDefaultValue:(XPExpression *)expr forParamNamed:(NSString *)name;

@property (nonatomic, retain) XPNode *blockNode;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *params;
@property (nonatomic, retain) NSArray<XPSymbol *> *orderedParams;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPExpression *> *defaultParamValues;
@end
