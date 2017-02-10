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

- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = NULL;

    if ([methName isEqualToString:@"length"]) {
        sel = @selector(length:);
    } else if ([methName isEqualToString:@"get"]) {
        sel = @selector(get::);
    } else if ([methName isEqualToString:@"set"]) {
        sel = @selector(set:::);
    } else if ([methName isEqualToString:@"append"]) {
        sel = @selector(append::);
    }
    TDAssert(sel);

    return sel;
}


- (id)length:(XPObject *)this {
    NSMutableArray *v = this.value;
    NSInteger c = [v count];
    return @(c);
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
