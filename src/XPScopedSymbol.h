//
//  XPScopedSymbol.h
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPSymbol.h"
#import "XPScope.h"

@interface XPScopedSymbol : XPSymbol <XPScope>

- (instancetype)initWithName:(NSString *)name enclosingScope:(id <XPScope>)scope;

- (NSMutableDictionary *)members; // abstract

@property (nonatomic, assign, readonly) id <XPScope>parentScope; // weakref - avoids cyle for func delcarations define in this scope
@property (nonatomic, assign, readonly) id <XPScope>enclosingScope; // weakref - "
@end
