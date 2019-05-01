//
//  XPStringClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPStringClass.h"
#import <Language/XPObject.h>
#import "XPIndexException.h"
#import "XPEnumeration.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) id value;
@end

@implementation XPStringClass

+ (instancetype)classInstance {
    TDAssertExecuteThread();
    static XPStringClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (NSString *)name {
    return @"String";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];
    
    if ([methName isEqualToString:@"count"]) {
        sel = @selector(count:);
    } else if ([methName isEqualToString:@"get"]) {
        sel = @selector(get::::);
#if MUTABLE_STRINGS
    } else if ([methName isEqualToString:@"set"]) {
        sel = @selector(set::::);
    } else if ([methName isEqualToString:@"append"]) {
        sel = @selector(append::);
#endif
    }
    TDAssert(sel);
    
    return sel;
}


- (id)count:(XPObject *)this {
    NSMutableString *s = this.value;
    NSInteger c = [s length];
    return @(c);
}


- (XPEnumeration *)enumeration:(XPObject *)this {
    NSString *s = this.value;
    NSUInteger c = [s length];
    NSMutableArray *v = [NSMutableArray arrayWithCapacity:c];
    
    for (NSUInteger i = 0; i < c; ++i) {
        [v addObject:[XPObject string:[NSString stringWithFormat:@"%C", [s characterAtIndex:i]]]];
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


- (void)checkBounds:(NSString *)s :(NSInteger)checkIdx {
    checkIdx = labs(checkIdx);
    NSInteger len = [s length];
    
    if (checkIdx < 1 || checkIdx > len) {
        [[[[XPIndexException alloc] initWithIndex:checkIdx first:1 last:len] autorelease] raise];
        return;
    }
}


- (XPObject *)get:(XPObject *)this :(NSInteger)start :(NSInteger)stop :(NSInteger)step {
    TDAssert(1 == step);
    
    XPObject *strObj = nil;
    NSMutableString *s = this.value;
    
    if (1 == start && -1 == stop && 1 == step) {
        // x[:] copy
        strObj = [XPObject string:s]; // mutable copies
    } else {
        [self checkBounds:s :start];
        [self checkBounds:s :stop];

        start = [self nativeIndexForIndex:start inString:s];
        stop = [self nativeIndexForIndex:stop inString:s];

        if (start == stop) {
            unichar c = [s characterAtIndex:start];
            strObj = [XPObject string:[NSString stringWithFormat:@"%C", c]];
        } else {
            NSMutableString *res = [NSMutableString stringWithCapacity:labs(stop-start)];
            
            for (NSInteger i = start; i <= stop; i += step) {
                unichar c = [s characterAtIndex:i];
                [res appendFormat:@"%C", c];
            }
            
            strObj = [XPObject string:res];
        }
    }
    
    return strObj;
}


- (void)set:(XPObject *)this :(NSInteger)start :(NSInteger)stop :(XPObject *)obj {
    NSMutableString *s = this.value;

    [self checkBounds:s :start];
    [self checkBounds:s :stop];

    start = [self nativeIndexForIndex:start inString:s];
    stop = [self nativeIndexForIndex:stop inString:s];
    
    if (start == stop) {
        [s replaceCharactersInRange:NSMakeRange(start, 1) withString:obj.stringValue];
    } else {
        NSString *head = [s substringWithRange:NSMakeRange(0, start)];
        NSString *tail = [s substringWithRange:NSMakeRange(stop+1, [s length]-1-stop)];
        NSMutableString *res = [NSMutableString stringWithString:head];
        
//        if (obj.isArrayObject) {
//            for (XPObject *el in obj.value) {
//                [res appendString:el.stringValue];
//            }
//        } else {
            [res appendString:obj.stringValue];
//        }
        
        [res appendString:tail];
        this.value = res;
    }
}


- (void)append:(XPObject *)this :(XPObject *)obj {
    NSMutableString *s = this.value;
    [s appendString:obj.stringValue];
}


- (NSString *)reprValue:(XPObject *)this {
    NSString *val = this.value;
    val = [val stringByReplacingOccurrencesOfString:@"'" withString:@"\\'" options:0 range:NSMakeRange(0, [val length])];
    return [NSString stringWithFormat:@"'%@'", val];
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
