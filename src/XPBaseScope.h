//
//  XPBaseScope.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScope.h"

@class XPSymbol;

@interface XPBaseScope : NSObject <NSCopying, XPScope>

+ (instancetype)scopeWithEnclosingScope:(id <XPScope>)scope;
- (instancetype)initWithEnclosingScope:(id <XPScope>)scope;

@property (nonatomic, assign, readonly) id <XPScope>parentScope; // only needed for OOP
@property (nonatomic, retain, readonly) id <XPScope>enclosingScope;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *symbols;
@end
