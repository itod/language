//
//  XPObject.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import <Language/XPObject.h>
#import "XPClass.h"
#import "XPNullClass.h"
#import "XPBooleanClass.h"
#import "XPNumberClass.h"
#import "XPStringClass.h"
#import "XPArrayClass.h"
#import "XPDictionaryClass.h"
#import "XPFunctionClass.h"
#import "XPParser.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) XPClass *objectClass;
@property (nonatomic, retain, readwrite) id value;
@end

@implementation XPObject

+ (instancetype)nullObject {
    TDAssertExecuteThread();
    return [[XPNullClass classInstance] nullObject];
}


+ (instancetype)nanObject {
    TDAssertExecuteThread();
    return [[XPNumberClass classInstance] nanObject];
}


+ (instancetype)positiveInfinityObject {
    TDAssertExecuteThread();
    return [[XPNumberClass classInstance] positiveInfinityObject];
}


+ (instancetype)negativeInfinityObject {
    TDAssertExecuteThread();
    return [[XPNumberClass classInstance] negativeInfinityObject];
}


+ (instancetype)trueObject {
    TDAssertExecuteThread();
    return [[XPBooleanClass classInstance] trueObject];
}


+ (instancetype)falseObject {
    TDAssertExecuteThread();
    return [[XPBooleanClass classInstance] falseObject];
}


+ (instancetype)boolean:(BOOL)b {
    return b ? [self trueObject] : [self falseObject];
}


+ (instancetype)number:(double)n {
    XPObject *obj = nil;
    if (isnan(n)) {
        obj = [self nanObject];
    } else if (isinf(n)) {
        if (n < 0.0) {
            obj = [self negativeInfinityObject];
        } else {
            obj = [self positiveInfinityObject];
        }
    } else {
        obj = [XPNumberClass instanceWithValue:@(n)];
    }
    return obj;
}


+ (instancetype)string:(NSString *)s {
    return [XPStringClass instanceWithValue:s];
}


+ (instancetype)array:(NSArray *)v {
    return [XPArrayClass instanceWithValue:v];
}


+ (instancetype)dictionary:(NSDictionary *)d {
    return [XPDictionaryClass instanceWithValue:d];
}


+ (instancetype)function:(XPFunctionSymbol *)funcSym {
    return [XPFunctionClass instanceWithValue:funcSym];
}


+ (instancetype)objectWithClass:(XPClass *)cls value:(id)val {
    TDAssert(cls);
    TDAssert(val);
    XPObject *obj = [cls internedObjectWithValue:val];
    if (!obj) {
        obj = [[[XPObject alloc] initWithClass:cls value:val] autorelease];
    }
    return obj;
}


- (instancetype)init {
    TDAssert(0);
    self = [self initWithClass:nil value:nil];
    return self;
}


- (instancetype)initWithClass:(XPClass *)cls value:(id)val {
    self = [super init];
    if (self) {
        self.objectClass = cls;
        
        if ([val respondsToSelector:@selector(mutableCopyWithZone:)]) {
            val = [[val mutableCopy] autorelease];
        } else if ([val respondsToSelector:@selector(copyWithZone:)]) {
            val = [[val copy] autorelease];
        }
        
        self.value = val;
    }
    return self;
}


- (void)dealloc {
    self.objectClass = nil;
    self.value = nil;
    [super dealloc];
}


- (NSString *)reprValue {
    //return [NSString stringWithFormat:@"<%@ %@>", [_objectClass name], _value];
    //return [NSString stringWithFormat:@"<%@ %@>", [_objectClass name], [self stringValue]];
    return [self.objectClass reprValue:self];
}


#pragma mark -
#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id val = _value;
//    id val = nil;
//    if ([_value respondsToSelector:@selector(mutableCopyWithZone:)]) {
//        val = [[_value mutableCopyWithZone:zone] autorelease];
//    } else {
//        val = [[_value copyWithZone:zone] autorelease];
//    }
    XPObject *that = [[XPObject objectWithClass:self.objectClass value:val] retain]; // val is copied in -init
    
    return that;
}


#pragma mark -
#pragma mark Method Invocation

- (id)callInstanceMethodNamed:(NSString *)name withArgs:(NSArray *)args {
    TDAssert(name);
    XPClass *cls = self.objectClass;
    
    NSInvocation *invoc = nil;
    NSMethodSignature *sig = [cls getInvocation:&invoc forMethodNamed:name];
    
    // set `this`
    NSInteger i = 2;
    [invoc setArgument:&self atIndex:i++];
    
    // set args
    for (id arg in args) {
        const char *argType = [sig getArgumentTypeAtIndex:i];
        
        if (0 == strcmp(@encode(NSInteger), argType)) {
            NSInteger x = [arg integerValue];
            [invoc setArgument:&x atIndex:i];
        }
        
        else if (0 == strcmp(@encode(id), argType)) {
            [invoc setArgument:&arg atIndex:i];
        }
        
        else {
            TDAssert(0);
        }
        
        ++i;
    }
    
    // invoke
    [invoc invokeWithTarget:cls];
    
    // get return val
    id retVal = nil;
    {
        const char *retType = [sig methodReturnType];

        if (0 == strcmp(@encode(void), retType)) {
            // noop
        }
        
        else if (0 == strcmp(@encode(BOOL), retType)) {
            BOOL b = NO;
            [invoc setArgument:&b atIndex:i];
            retVal = @(b);
        }
        
        else if (0 == strcmp(@encode(double), retType)) {
            double x = 0.0;
            [invoc setArgument:&x atIndex:i];
            retVal = @(x);
        }
        
        else if (0 == strcmp(@encode(id), retType)) {
            [invoc getReturnValue:&retVal];
        }

        else {
            TDAssert(0);
        }
    }
    
    return retVal;
}


- (id)callInstanceMethodNamed:(NSString *)name {
    return [self callInstanceMethodNamed:name withArgs:nil];
}


- (id)callInstanceMethodNamed:(NSString *)name withArg:(id)arg {
    return [self callInstanceMethodNamed:name withArgs:@[arg]];
}


#pragma mark -
#pragma mark Public

- (XPObject *)asBooleanObject {
    return [XPObject boolean:[self boolValue]];
}


- (XPObject *)asNumberObject {
    return [XPObject number:[self doubleValue]];
}


- (XPObject *)asStringObject {
    return [XPObject string:[self stringValue]];
}


- (NSString *)stringValue {
    return [self.objectClass stringValue:self];
}


- (double)doubleValue {
    return [[self.objectClass doubleValue:self] doubleValue];
}


- (NSInteger)integerValue {
    return lround(self.doubleValue);
}


- (BOOL)boolValue {
    return [[self.objectClass boolValue:self] boolValue];
}


- (BOOL)isEqualToObject:(XPObject *)other {
    
    if ([self isBooleanObject] || [other isBooleanObject]) {
        return [self boolValue] == [other boolValue];
    }
    
    if ([self isNumericObject] || [other isNumericObject]) {
        return [self doubleValue] == [other doubleValue];
    }
    
    if ([self isStringObject] || [other isStringObject]) {
        return [[self stringValue] isEqualToString:[other stringValue]];
    }

    return _objectClass == other->_objectClass && [_value isEqual:other->_value];
}


- (BOOL)isNotEqualToObject:(XPObject *)other {
    
    return ![self isEqualToObject:other];
}


- (BOOL)compareToObject:(XPObject *)other usingOperator:(NSInteger)op {
    
    if (op == XP_TOKEN_KIND_EQ) return [self isEqualToObject:other];
    if (op == XP_TOKEN_KIND_NE) return [self isNotEqualToObject:other];
    if (op == XP_TOKEN_KIND_IS) return self == other;
    
    return [self compareNumber:[self doubleValue] toNumber:[other doubleValue] usingOperator:op];
}


- (BOOL)compareNumber:(double)x toNumber:(double)y usingOperator:(NSInteger)op {
    switch (op) {
        case XP_TOKEN_KIND_LT:
            return x < y;
        case XP_TOKEN_KIND_LE:
            return x <= y;
        case XP_TOKEN_KIND_GT:
            return x > y;
        case XP_TOKEN_KIND_GE:
            return x >= y;
        default:
            return NO;
    }
}


- (BOOL)isEqual:(id)obj {
    if (![obj isMemberOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToObject:obj];
}


- (NSUInteger)hash {
    return [self.value hash];
}


- (XPEnumeration *)enumeration {
    return [self.objectClass enumeration:self];
}


- (BOOL)isBooleanObject {
    return [self.objectClass isKindOfClass:[XPBooleanClass class]];
}


- (BOOL)isNumericObject {
    return [self.objectClass isKindOfClass:[XPNumberClass class]];
}


- (BOOL)isStringObject {
    return [self.objectClass isKindOfClass:[XPStringClass class]];
}


- (BOOL)isFunctionObject {
    return [self.objectClass isKindOfClass:[XPFunctionClass class]];
}


- (BOOL)isArrayObject {
    return [self.objectClass isKindOfClass:[XPArrayClass class]];
}


- (BOOL)isDictionaryObject {
    return [self.objectClass isKindOfClass:[XPDictionaryClass class]];
}

@end
