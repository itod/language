//
//  XPScope.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPSymbol;

@protocol XPScope <NSObject>

- (NSString *)scopeName;
- (id <XPScope>)enclosingScope;

- (void)defineSymbol:(XPSymbol *)sym;
- (XPSymbol *)resolveSymbolNamed:(NSString *)name;
@end
