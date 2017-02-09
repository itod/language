//
//  XPClass.h
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;

@interface XPClass : NSObject

- (XPObject *)internedObjectWithValue:(id)val;
- (NSMethodSignature *)methodSignatureForMethodNamed:(NSString *)methName;
@end
