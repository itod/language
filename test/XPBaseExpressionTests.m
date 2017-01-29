//
//  XPBaseExpressionTests.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseExpressionTests.h"

@implementation XPBaseExpressionTests

- (XPParser *)parser {
    XPParser *p = [super parser];
    p.allowNakedExpressions = YES;
    return p;
}

@end
