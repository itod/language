//
//  XPMemorySpace.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;

@interface XPMemorySpace : NSObject

- (instancetype)initWithName:(NSString *)name enclosingSpace:(XPMemorySpace *)space;

- (XPObject *)objectForName:(NSString *)name;
- (void)setObject:(XPObject *)obj forName:(NSString *)name;

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, retain, readonly) XPMemorySpace *enclosingSpace;
@property (nonatomic, retain, readonly) NSMutableDictionary<NSString *, XPObject *> *members;
@end
