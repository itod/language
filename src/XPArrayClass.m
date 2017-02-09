//
//  XPArrayClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPArrayClass.h"

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


- (id)get:(id)this :(NSInteger)idx {
    return nil;
}


- (void)set:(id)this :(NSInteger)idx :(id)obj {

}


- (void)append:(id)this :(id)obj {
    
}

@end
