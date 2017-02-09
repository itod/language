//
//  XPObject.m
//  Language
//
//  Created by Todd Ditchendorf on 2/9/17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPObject.h"
#import "XPClass.h"

@interface XPObject ()
@property (nonatomic, retain, readwrite) XPClass *class;
@property (nonatomic, retain, readwrite) id value;
@end

@implementation XPObject

+ (instancetype)null {
    TDAssertMainThread();
    static XPObject *null = nil;
    if (!null) {
        null = [[XPObject alloc] initWithClass:nil value:nil];
    }
    return null;
}


+ (instancetype)objectWithClass:(XPClass *)cls value:(id)val {
    TDAssert(cls);
    TDAssert(val);
    XPObject *obj = [cls internedObjectWithValue:val];
    if (!obj) {
        obj = [[[self alloc] initWithClass:cls value:val] autorelease];
    }
    return obj;
}


- (instancetype)init {
    TDAssert(0);
    self = [super init];
    return self;
}


- (instancetype)initWithClass:(XPClass *)cls value:(id)val {
    self = [super init];
    if (self) {
        self.class = cls;
        self.value = val;
    }
    return self;
}


- (void)dealloc {
    self.class = nil;
    self.value = nil;
    [super dealloc];
}


- (id)callInstanceMethodNamed:(NSString *)name args:(NSArray *)args {
    TDAssert(name);
    XPClass *cls = self.class;
    
    NSInvocation *invoc = nil;
    NSMethodSignature *sig = [cls getInvocation:&invoc forMethodNamed:name];
    
    // set `this`
    NSInteger i = 2;
    [invoc setArgument:&self atIndex:i++];
    
    // set args
    for (id arg in args) {
        const char *type = [sig getArgumentTypeAtIndex:i];
        if (0 == strcmp(@encode(NSInteger), type)) {
            NSInteger x = [arg integerValue];
            [invoc setArgument:&x atIndex:i];
        }
        ++i;
    }
    
    // invoke
    [invoc invokeWithTarget:cls];
    
    // get return val
    id retVal = nil;
    [invoc getReturnValue:&retVal];
    
    return retVal;
}


- (id)callInstanceMethodNamed:(NSString *)name withArg:(id)arg {
    return [self callInstanceMethodNamed:name args:@[arg]];
}

@end
