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
@property (nonatomic, copy) NSString *filename;
@property (nonatomic, copy) NSString *functionName;
@property (nonatomic, retain) NSDictionary <NSString *, XPObject *>*locals;
@end
