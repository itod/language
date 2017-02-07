//
//  XPMemorySpace.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPValue;

@interface XPMemorySpace : NSObject

- (instancetype)initWithName:(NSString *)name;

- (XPValue *)objectForName:(NSString *)name;
- (void)setObject:(XPValue *)obj forName:(NSString *)name;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, XPValue *> *members;
@end
