//
//  XPSymbol.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XPScope;

@interface XPSymbol : NSObject
+ (NSSet *)reservedWords;

+ (instancetype)symbolWithName:(NSString *)name;
- (instancetype)initWithName:(NSString *)name;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) id <XPScope>scope; // weakref
@end
