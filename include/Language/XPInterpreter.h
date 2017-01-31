//
//  XPInterpreter.h
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const XPErrorDomain;
extern NSString * const XPErrorRangeKey;
extern NSString * const XPErrorLineNumberKey;

@class XPGlobalScope;
@class XPMemorySpace;
@class XPNode;
@class XPParser;

@interface XPInterpreter : NSObject

- (void)interpretString:(NSString *)input error:(NSError **)outErr;

@property (nonatomic, retain) XPGlobalScope *globalScope;
@property (nonatomic, retain) XPMemorySpace *globals;
@property (nonatomic, retain) XPNode *root;               // the AST represents our code memory
@property (nonatomic, retain) XPParser *parser;
@end
