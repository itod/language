//
//  XPException.h
//  Language
//
//  Created by Todd Ditchendorf on 31.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XPExceptionUndeclaredSymbol;
extern NSString * const XPExceptionTooManyArguments;
extern NSString * const XPExceptionParamMisordered;

@interface XPException : NSException
@property (nonatomic, assign) NSUInteger lineNumber;
@property (nonatomic, assign) NSRange range;
@end
