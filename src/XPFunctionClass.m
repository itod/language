//
//  XPFunctionClass.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionClass.h"
#import "XPFunctionSymbol.h"
#import <Language/XPObject.h>

@interface XPObject ()
- (instancetype)initWithClass:(XPClass *)cls value:(id)val;
@end

@interface XPFunctionClass ()
@property (nonatomic, retain) NSMutableDictionary *cache;
@end

@implementation XPFunctionClass

+ (instancetype)classInstance {
    TDAssertMainThread();
    static XPFunctionClass *cls = nil;
    if (!cls) {
        cls = [[self alloc] init];
    }
    return cls;
}


- (XPObject *)internedObjectWithValue:(id)val {
    TDAssertMainThread();
    TDAssert([val isKindOfClass:[XPFunctionSymbol class]]);
    
    XPFunctionSymbol *funcSym = (id)val;
    
    XPObject *res = self.cache[funcSym.name];
    if (!res) {
        res = [[[XPObject alloc] initWithClass:self value:val] autorelease];
        self.cache[funcSym.name] = res;
    }
    
    return res;
}


- (NSString *)name {
    return @"Subroutine";
}


- (SEL)selectorForMethodNamed:(NSString *)methName {
    SEL sel = [super selectorForMethodNamed:methName];
    TDAssert(sel);
    return sel;
}


- (id)stringValue:(XPObject *)this {
    return @"[Object Subroutine]"; // TODO
}


- (id)doubleValue:(XPObject *)this {
    return @1;
}


- (id)boolValue:(XPObject *)this {
    return @YES;
}

@end
