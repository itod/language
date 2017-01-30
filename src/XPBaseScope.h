//
//  XPBaseScope.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPScope.h"

@class XPSymbol;

@interface XPBaseScope : NSObject <XPScope>

- (instancetype)initWithEnclosingScope:(id <XPScope>)outer;

@property (nonatomic, retain, readonly) id <XPScope>parentScope;
@property (nonatomic, retain, readonly) id <XPScope>enclosingScope;
@property (nonatomic, retain) NSMutableDictionary<NSString *, XPSymbol *> *symbols;
@end
