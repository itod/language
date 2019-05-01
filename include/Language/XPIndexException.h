//
//  XPIndexException.h
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPException.h>

@class XPObject;

@interface XPIndexException : XPException

- (instancetype)initWithIndex:(NSInteger)index first:(NSInteger)first last:(NSInteger)last;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger first;
@property (nonatomic, assign) NSInteger last;
@end
