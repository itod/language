//
//  XPUserThrownException.h
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPException.h>

@class XPObject;

@interface XPUserThrownException : XPException

- (instancetype)initWithThrownObject:(XPObject *)obj;

@property (nonatomic, retain) XPObject *thrownObject;
@end
