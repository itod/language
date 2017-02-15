//
//  FNMatches.h
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionBody.h"

@interface FNMatches : XPFunctionBody
+ (NSRegularExpressionOptions)regexOptionsForString:(NSString *)flags;
@end
