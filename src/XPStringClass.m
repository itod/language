//
//  XPStringClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStringClass.h"
#import "XPObject.h"
#import "XPEnumeration.h"

@implementation XPStringClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPStringClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];
    
    if ([methName isEqualToString:@"count"]) {
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
    NSMutableString *s = this.value;
    NSInteger c = [s length];
    return @(c);
}


- (XPEnumeration *)enumeration:(XPObject *)this {
    NSString *s = this.value;
    NSUInteger c = [s length];
    NSMutableArray *v = [NSMutableArray arrayWithCapacity:c];
    
    for (NSUInteger i = 0; i < c; ++i) {
        [v addObject:[XPStringClass instanceWithValue:[NSString stringWithFormat:@"%C", [s characterAtIndex:i]]]];
    }
    
    XPEnumeration *e = [XPEnumeration enumerationWithValues:v];
    return e;
}


- (NSInteger)nativeIndexForIndex:(NSInteger)inIdx inString:(NSString *)s {
    NSInteger outIdx = inIdx;
    
    if (inIdx < 0) {
        NSUInteger c = [s length];
        outIdx = c+outIdx;
    } else {
        outIdx = inIdx-1;
    }
    
    return outIdx;
}


- (XPObject *)get:(XPObject *)this :(NSInteger)idx {
    NSMutableString *s = this.value;
    idx = [self nativeIndexForIndex:idx inString:s];
    unichar res = [s characterAtIndex:idx];
    return [XPStringClass instanceWithValue:[NSString stringWithFormat:@"%C", res]];
}


- (void)set:(XPObject *)this :(NSInteger)idx :(XPObject *)obj {
    if (![obj isStringObject]) {
        @throw obj; // TODO
    }
    NSMutableString *s = this.value;
    idx = [self nativeIndexForIndex:idx inString:s];
    [s replaceCharactersInRange:NSMakeRange(idx, 1) withString:obj.value];
}


- (void)append:(XPObject *)this :(XPObject *)obj {
    if (![obj isStringObject]) {
        @throw obj; // TODO
    }
    NSMutableString *s = this.value;
    [s appendString:obj.value];
}


- (id)stringValue:(XPObject *)this {
    return this.value;
}


- (id)doubleValue:(XPObject *)this {
    return @([this.value doubleValue]);
}


- (id)boolValue:(XPObject *)this {
    return [this.value length] ? @YES : @NO;
}

@end
