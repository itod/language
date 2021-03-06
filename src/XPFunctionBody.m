//
//  XPFunctionBody.m
//  Language
//
//  Created by Todd Ditchendorf on 2/14/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionBody.h"
#import <Language/XPException.h>
#import <Language/XPObject.h>

@implementation XPFunctionBody

+ (NSString *)name {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)dealloc {
    TDAssert(!_dynamicSpace); // should have been nil'ed already
    self.dynamicSpace = nil;
    [super dealloc];
}


- (XPFunctionSymbol *)symbol {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (XPObject *)callWithWalker:(XPTreeWalker *)walker functionSpace:(XPMemorySpace *)space argc:(NSUInteger)argc {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)raise:(NSString *)name format:(NSString *)fmt, ... {
    va_list vargs;
    va_start(vargs, fmt);
    
    NSString *msg = [[[NSString alloc] initWithFormat:fmt arguments:vargs] autorelease];
    
    va_end(vargs);
    
    XPException *ex = [[[XPException alloc] initWithName:name reason:msg userInfo:nil] autorelease];
    [ex raise];
}


- (void)checkNumberArgument:(XPObject *)obj {
    if (!obj.isNumericObject) {
        NSString *name = [[self class] name];
        NSString *type = [obj.objectClass name];
        NSString *reason = [NSString stringWithFormat:@"argument to %@() must be a Number, not '%@'", name, type];
        [[[[XPException alloc] initWithName:XPTypeError reason:reason userInfo:nil] autorelease] raise];
    }
}

@end
