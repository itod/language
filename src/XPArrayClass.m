//
//  XPArrayClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPArrayClass.h"
#import <Language/XPObject.h>
#import <Language/XPIndexException.h>
#import "XPEnumeration.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) id value;
@end

@implementation XPArrayClass

+ (instancetype)classInstance {
    TDAssertExecuteThread();
    static XPArrayClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (NSString *)name {
    return @"Array";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];

    if ([methName isEqualToString:@"count"]) {
        sel = @selector(count:);
    } else if ([methName isEqualToString:@"get"]) {
        sel = @selector(get::::);
    } else if ([methName isEqualToString:@"set"]) {
        sel = @selector(set::::);
    } else if ([methName isEqualToString:@"append"]) {
        sel = @selector(append::);
    }
    TDAssert(sel);

    return sel;
}


- (XPEnumeration *)enumeration:(XPObject *)this {
    XPEnumeration *e = [XPEnumeration enumerationWithValues:[[this.value copy] autorelease]];
    return e;
}


- (id)count:(XPObject *)this {
    NSMutableArray *v = this.value;
    NSInteger c = [v count];
    return @(c);
}


- (NSInteger)nativeIndexForIndex:(NSInteger)inIdx inArray:(NSArray *)v {
    NSInteger outIdx = inIdx;
    
    if (inIdx < 0) {
        NSUInteger c = [v count];
        outIdx = c+outIdx;
    } else {
        outIdx = inIdx-1;
    }
    
    return outIdx;
}


- (NSInteger)indexForNativeIndex:(NSInteger)inIdx {
    NSInteger outIdx = inIdx+1;
    return outIdx;
}


- (XPObject *)get:(XPObject *)this :(NSInteger)start :(NSInteger)stop :(NSInteger)step {
    NSMutableArray *v = this.value;
    NSInteger nativeStart = [self nativeIndexForIndex:start inArray:v];
    NSInteger nativeStop = [self nativeIndexForIndex:stop inArray:v];
    
    NSInteger nativeLast = [v count]-1;
    if (0 == start) {
        NSInteger last = [self indexForNativeIndex:nativeLast];
        [XPIndexException raise:XPIndexError format:@"Index `%ld` out of range `1–%ld`.", start, last];
        return nil;
    }

    XPObject *arrObj = nil;
    
    if (nativeStart == nativeStop) {
        arrObj = [v objectAtIndex:nativeStart];
    } else {
        NSMutableArray *res = [NSMutableArray arrayWithCapacity:labs(nativeStop-nativeStart)];
        
        for (NSInteger i = nativeStart; i <= nativeStop; i += step) {
            XPObject *obj = [v objectAtIndex:i];
            [res addObject:obj];
        }
        
        arrObj = [XPObject array:res];
    }
    
    return arrObj;
}


- (void)set:(XPObject *)this :(NSInteger)start :(NSInteger)stop :(XPObject *)obj {
    NSMutableArray *v = this.value;
    start = [self nativeIndexForIndex:start inArray:v];
    stop = [self nativeIndexForIndex:stop inArray:v];
    
    if (start == stop) {
        [v replaceObjectAtIndex:start withObject:obj];
    } else {
        NSArray *head = [v subarrayWithRange:NSMakeRange(0, start)];
        NSRange r = NSMakeRange(stop+1, [v count]-1-stop);
        NSArray *tail = [v subarrayWithRange:r];
        NSMutableArray *res = [NSMutableArray arrayWithArray:head];
        
        if (obj.isArrayObject) {
            for (id el in obj.value) {
                [res addObject:el];
            }
        } else {
            [res addObject:obj];
        }
        [res addObjectsFromArray:tail];
        this.value = res;
    }
}


- (void)append:(XPObject *)this :(XPObject *)obj {
    NSMutableArray *v = this.value;
    [v addObject:obj];
}


- (NSString *)reprValue:(XPObject *)this {
    return [self repr:this withSelector:@selector(reprValue)];
}


- (id)stringValue:(XPObject *)this {
    return [self repr:this withSelector:@selector(stringValue)];
}


- (NSString *)repr:(XPObject *)this withSelector:(SEL)sel {
    NSMutableString *buf = [NSMutableString stringWithString:@"["];
    
    TDAssert(this.value);
    NSUInteger c = [this.value count];
    NSUInteger i = 0;
    for (id obj in this.value) {
        [buf appendFormat:@"%@%@", [obj performSelector:sel], i++ == c-1 ? @"" : @", "];
    }
    
    [buf appendString:@"]"];
    
    return buf;
}


//- (NSString *)repr:(XPObject *)this withSelector:(SEL)sel {
//    BOOL isDesc = sel == @selector(description);
//    NSMutableString *buf = [NSMutableString stringWithString:isDesc ? @"[" : @""];
//    
//    TDAssert(this.value);
//    NSUInteger c = [this.value count];
//    NSUInteger i = 0;
//    for (id obj in this.value) {
//        [buf appendFormat:@"%@%@", [obj performSelector:sel], i++ == c-1 ? @"" : isDesc ? @", " : @""];
//    }
//    
//    [buf appendString:isDesc ? @"]" : @""];
//    
//    return buf;
//}


- (id)doubleValue:(XPObject *)this {
    return [this.value count] > 0 ? @1.0 : @0.0;
}


- (id)boolValue:(XPObject *)this {
    return [this.value count] > 0 ? @YES : @NO;
}

@end
