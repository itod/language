//
//  XPException.h
//  Language
//
//  Created by Todd Ditchendorf on 31.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 Exception
    RuntimeError
        ArithmeticError
            OverflowError
            ZeroDivisionError
            FloatingPointError
        LookupError
            IndexError
            KeyError ??
        EnvironmentError
            IOError
            OSError
        AssertionError
        ImportError
        NameError
        SyntaxError
        TypeError
        ValueError
    
    UserInterruptException
*/

extern NSString * const XPRuntimeError;
    extern NSString * const XPArithmeticError;
        extern NSString * const XPZeroDivisionError;
    extern NSString * const XPLookupError;
        extern NSString * const XPIndexError;
    extern NSString * const XPEnvironmentError;
        extern NSString * const XPIOError;
        extern NSString * const XPOSError;
    extern NSString * const XPAssertionError;
    extern NSString * const XPImportError;
    extern NSString * const XPNameError;
    extern NSString * const XPSyntaxError;
    extern NSString * const XPRegexSyntaxError;
    extern NSString * const XPTypeError;
    extern NSString * const XPValueError;

extern NSString * const XPUserInterruptException;

@interface XPException : NSException
@property (nonatomic, assign) NSUInteger lineNumber;
@property (nonatomic, assign) NSRange range;
@end
