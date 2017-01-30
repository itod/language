//
//  XPMemorySpace.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPMemorySpace : NSObject

- (instancetype)initWithName:(NSString *)name;

- (id)objectForName:(NSString *)name;
- (void)setObject:(id)obj forName:(NSString *)name;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, id> *members;
@end
