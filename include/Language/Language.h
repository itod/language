//
//  Language.h
//  Language
//
//  Created by Todd Ditchendorf on 27.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for Language.
FOUNDATION_EXPORT double LanguageVersionNumber;

//! Project version string for Language.
FOUNDATION_EXPORT const unsigned char LanguageVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <Language/PublicHeader.h>

#import <Language/XPNode.h>
#import <Language/XPTreeWalker.h>
#import <Language/XPInterpreter.h>
#import <Language/XPException.h>
#import <Language/XPUserThrownException.h>
#import <Language/XPObject.h>

// DEBUG
#import <Language/XPStackFrame.h>
#import <Language/XPBreakpoint.h>
#import <Language/XPBreakpointCollection.h>
