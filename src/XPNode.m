//
//  XPNode.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPNode.h"

@implementation XPNode

+ (instancetype)nodeWithToken:(PKToken *)tok {
    return [self ASTWithToken:tok];
}

@end
