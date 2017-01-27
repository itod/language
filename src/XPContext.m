// The MIT License (MIT)
//
// Copyright (c) 2014 Todd Ditchendorf
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Language/XPContext.h>

@interface XPContext ()
@property (nonatomic, retain) NSMutableDictionary *vars;
@end

@implementation XPContext

- (instancetype)init {
    self = [self initWithVariables:nil];
    return self;
}


- (instancetype)initWithVariables:(NSDictionary *)vars {
    self = [super init];
    if (self) {
        self.vars = [NSMutableDictionary dictionary];
        [_vars addEntriesFromDictionary:vars];
    }
    return self;
}


- (void)dealloc {
    self.vars = nil;
    self.enclosingScope = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p global: %d, %@>", [self class], self, nil == self.enclosingScope, self.vars];
}


#pragma mark -
#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    XPContext *ctx = [[XPContext alloc] initWithVariables:nil];
    ctx.enclosingScope = self;
    return ctx;
}


#pragma mark -
#pragma mark TDScope

- (id)resolveVariable:(NSString *)name {
    NSParameterAssert([name length]);
    TDAssert(_vars);
    id result = _vars[name];
    
    if (!result && self.enclosingScope) {
        result = [self.enclosingScope resolveVariable:name];
    }
    
    return result;
}


- (void)defineVariable:(NSString *)name value:(id)value {
    //NSLog(@"%s %@=%@", __PRETTY_FUNCTION__, name, value);

    NSParameterAssert([name length]);
    TDAssert(_vars);
    if (value) {
        _vars[name] = value;
    } else {
        //TDAssert(_vars[name]);
        [_vars removeObjectForKey:name];
    }
}

@end
