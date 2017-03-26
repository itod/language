//
//  XPException.m
//  Language
//
//  Created by Todd Ditchendorf on 31.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPException.h>

// static
NSString * const XPExceptionSyntaxError = @"Syntax Error";
NSString * const XPExceptionReservedWord = @"Reserved Word";

// runtime
NSString * const XPExceptionUserKill = @"User Stopped Execution";
NSString * const XPExceptionUncaughtThrownObject = @"Uncaught User-Thrown Object";
NSString * const XPExceptionRegexError = @"Regular Expression Error";
NSString * const XPExceptionUndeclaredSymbol = @"Undeclared Symbol";
NSString * const XPExceptionTooManyArguments = @"Too Many Arguments";
NSString * const XPExceptionTooFewArguments = @"Too Few Arguments";
NSString * const XPExceptionTypeMismatch = @"Type Mismatch";
NSString * const XPExceptionArrayIndexOutOfBounds = @"Array Index Out of Bounds";
NSString * const XPExceptionAssertionFailed = @"Assertion Failed";
NSString * const XPExceptionIllegalArgument = @"Illegal Argument";

@implementation XPException

@end
