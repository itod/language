//
//  XPRuntimeException.h
//  Language
//
//  Created by Todd Ditchendorf on 3/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPException.h"

@class XPObject;

@interface XPRuntimeException : XPException
@property (nonatomic, retain) XPObject *thrownObject;
@end
