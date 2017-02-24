//
//  XPBreakpointCollection.h
//  Editor
//
//  Created by Todd Ditchendorf on 8/1/13.
//  Copyright (c) 2013 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPBreakpoint;

@interface XPBreakpointCollection : NSObject <NSCopying> // NSSecureCoding>

+ (instancetype)fromPlist:(NSDictionary *)plist;
- (instancetype)initFromPlist:(NSDictionary *)plist;
- (NSDictionary *)asPlist;

- (NSArray *)allBreakpoints;
- (NSArray *)allFiles;

- (NSDictionary *)breakpointsDictionaryForFile:(NSString *)path;

- (NSSet *)breakpointsForFile:(NSString *)path;
- (NSArray *)sortedBreakpointsForFile:(NSString *)path;

- (void)addBreakpoint:(XPBreakpoint *)bp;
- (void)removeBreakpoint:(XPBreakpoint *)bp;
- (void)removeBreakpointsForFile:(NSString *)path;
@end
