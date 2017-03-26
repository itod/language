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
        AttributeError
        ImportError
        NameError
        SyntaxError
        TypeError/IllegalArgumentError/ValueError ??
    
    UserInterruptException
*/


typedef NS_ENUM(NSUInteger, XPExceptionCode) {
    XPExceptionCodeCompileTime,
    XPExceptionCodeRuntime,
};

// static
extern NSString * const XPExceptionSyntaxError;
extern NSString * const XPExceptionReservedWord;
extern NSString * const XPExceptionUndeclaredSymbol;
extern NSString * const XPExceptionTooManyArguments;
extern NSString * const XPExceptionTooFewArguments;

// runtime
extern NSString * const XPExceptionUserKill;
extern NSString * const XPExceptionUncaughtThrownObject;
extern NSString * const XPExceptionRegexError;
extern NSString * const XPExceptionTypeMismatch;
extern NSString * const XPExceptionArrayIndexOutOfBounds;
extern NSString * const XPExceptionAssertionFailed;
extern NSString * const XPExceptionIllegalArgument;

@interface XPException : NSException
@property (nonatomic, assign) NSUInteger lineNumber;
@property (nonatomic, assign) NSRange range;
@end
