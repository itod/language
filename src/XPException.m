//
//  XPException.m
//  Language
//
//  Created by Todd Ditchendorf on 31.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPException.h>
NSString * const XPRuntimeError = @"RuntimeError";
    NSString * const XPArithmeticError = @"ArithmeticError";
        NSString * const XPZeroDivisionError = @"ZeroDivisionError";
    NSString * const XPLookupError = @"LookupError";
        NSString * const XPIndexError = @"IndexError";
    NSString * const XPEnvironmentError = @"EnvironmentError";
        NSString * const XPIOError = @"IOError";
        NSString * const XPOSError = @"OSError";
    NSString * const XPAssertionError = @"AssertionError";
    NSString * const XPImportError = @"ImportError";
    NSString * const XPNameError = @"NameError";
    NSString * const XPSyntaxError = @"SyntaxError";
    NSString * const XPRegexSyntaxError = @"RegexSyntaxError";
    NSString * const XPTypeError = @"TypeError";
    NSString * const XPValueError = @"ValueError";

NSString * const XPUserInterruptException = @"UserInterruptException";

@implementation XPException

@end
