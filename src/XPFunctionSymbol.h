//
//  XPFunctionSymbol.h
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScopedSymbol.h"

@class XPNode;

@interface XPFunctionSymbol : XPScopedSymbol

+ (instancetype)symbolWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;
- (instancetype)initWithName:(NSString *)name enclosingScope:(id<XPScope>)scope;

@property (nonatomic, retain) XPNode *blockNode;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *params;
@end
