//
//  XPFunctionSymbol.m
//  Language
//
//  Created by Todd Ditchendorf on 01.02.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPFunctionSymbol.h"

@implementation XPFunctionSymbol

+ (instancetype)symbolWithName:(NSString *)name enclosingScope:(id<XPScope>)scope {
    return [[[self alloc] initWithName:name enclosingScope:scope] autorelease];
}


- (instancetype)initWithName:(NSString *)name enclosingScope:(id<XPScope>)scope {
    self = [super initWithName:name enclosingScope:scope];
    if (self) {
        self.params = [NSMutableDictionary dictionary];
        self.members = [NSMutableDictionary dictionary];
        self.orderedParams = [NSMutableArray array];
    }
    return self;
}


- (void)dealloc {
    self.blockNode = nil;
    self.nativeBody = nil;
    self.closureSpace = nil;
    self.params = nil;
    self.members = nil;
    self.orderedParams = nil;
    self.defaultParamExpressions = nil;
    self.defaultParamObjects = nil;
    [super dealloc];
}


#pragma mark -
#pragma mark XPSymbol

// CAREFUL
//- (NSString *)name {
//    return [NSString stringWithFormat:@"%@ (%@)", [super name], [[_params allKeys] componentsJoinedByString:@","]];
//}


#pragma mark -
#pragma mark XPScopedSymbol

- (XPSymbol *)resolveSymbolNamed:(NSString *)name {
    TDAssertExecuteThread();
    TDAssert([name length]);
    TDAssert(self.params);
    TDAssert(self.members);
    
    XPSymbol *sym = [self.members objectForKey:name];
    
    if (!sym) {
        sym = [self.params objectForKey:name];
    }
    
    if (!sym) {
        sym = [self.parentScope resolveSymbolNamed:name];
    }
    
    return sym;
}


#pragma mark -
#pragma mark XPFunctionSymbol

- (void)setDefaultExpression:(XPNode *)val forParamNamed:(NSString *)name {
    TDAssert(val);
    TDAssert([name length]);
    
    if (!_defaultParamExpressions) {
        self.defaultParamExpressions = [NSMutableDictionary dictionary];
    }
    
    TDAssert(_defaultParamExpressions);
    [_defaultParamExpressions setObject:val forKey:name];
}


- (void)setDefaultObject:(XPObject *)obj forParamNamed:(NSString *)name {
    TDAssert(obj);
    TDAssert([name length]);
    
    if (!_defaultParamObjects) {
        self.defaultParamObjects = [NSMutableDictionary dictionary];
    }
    
    TDAssert(_defaultParamObjects);
    [_defaultParamObjects setObject:obj forKey:name];
}


- (XPNode *)lineNumberNode {
    return _blockNode;
}

@end
