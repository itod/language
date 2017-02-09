//
//  XPArrayClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPArrayClass.h"
#import "XPObject.h"

@implementation XPArrayClass

- (NSMethodSignature *)methodSignatureForMethodNamed:(NSString *)methName {
    NSMethodSignature *sig = nil;
    
    if ([methName isEqualToString:@"get"]) {
        sig = [self methodSignatureForSelector:@selector(get::)];
    } else if ([methName isEqualToString:@"set"]) {
        sig = [self methodSignatureForSelector:@selector(set:::)];
    } else if ([methName isEqualToString:@"append"]) {
        sig = [self methodSignatureForSelector:@selector(append::)];
    }
    
    TDAssert(sig);
    return sig;
}


- (id)get:(XPObject *)this :(NSInteger)idx {
    NSMutableArray *v = this.value;
    id res = [v objectAtIndex:idx];
    return res;
}


- (void)set:(XPObject *)this :(NSInteger)idx :(id)obj {
    NSMutableArray *v = this.value;
    [v insertObject:obj atIndex:idx];
}


- (void)append:(XPObject *)this :(id)obj {
    NSMutableArray *v = this.value;
    [v addObject:obj];
}

@end
