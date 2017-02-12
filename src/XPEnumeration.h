//
//  XPEnumerator.h
//  Language
//
//  Created by Todd Ditchendorf on 2/12/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XPEnumeration : NSObject

+ (instancetype)enumerationWithValues:(NSArray *)vals;
- (instancetype)initWithValues:(NSArray *)vals;

- (BOOL)hasMore;

@property (nonatomic, retain) NSArray *values;
@property (nonatomic, assign) NSInteger current;
@end
