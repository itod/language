//
//  XPFunctionBody.h
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;
@class XPFunctionSymbol;
@class XPTreeWalker;
@class XPMemorySpace;

@interface XPFunctionBody : NSObject
+ (NSString *)name;
- (XPFunctionSymbol *)symbol;
- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc;
- (void)raise:(NSString *)name format:(NSString *)fmt, ...;
- (void)checkNumberArgument:(XPObject *)obj;

// the space from which this function was called at runtime. used on in locals() currently
@property (nonatomic, retain) XPMemorySpace *dynamicSpace;
@end
