//
//  XPReturnException.h
//  Language
//
//  Created by Todd Ditchendorf on 2/15/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;

@interface XPReturnExpception : NSException
@property (nonatomic, retain) XPObject *value;
@end

@interface XPBreakException : NSException
@end

@interface XPContinueException : NSException
@end

@interface XPThrownException : NSException
@end

