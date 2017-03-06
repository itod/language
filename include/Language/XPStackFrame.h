//
//  XPStackFrame.h
//  Language
//
//  Created by Todd Ditchendorf on 2/23/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XPObject;

@interface XPStackFrame : NSObject

- (void)setMembers:(NSDictionary *)members;

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, copy) NSString *functionName;
@property (nonatomic, retain) NSArray *sortedLocalNames;
@property (nonatomic, retain) NSArray *sortedLocalValues;
@end
