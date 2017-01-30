//
//  XPTreeWalkerDefn.m
//  Language
//
//  Created by Todd Ditchendorf on 30.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPTreeWalkerDefn.h"
#import "XPMemorySpace.h"
#import "XPNode.h"
#import "XPValue.h"

@implementation XPTreeWalkerDefn

- (void)varDeclStat:(XPNode *)node {
    NSString *name = [[node.children[0] token] stringValue];
    XPExpression *expr = node.children[1];
    XPValue *val = [expr evaluateInContext:nil];
    
    TDAssert(self.currentSpace);
    [self.currentSpace setObject:val forName:name];
}

@end
