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
    }
    return self;
}


- (void)dealloc {
    self.blockNode = nil;
    self.params = nil;
    self.orderedParams = nil;
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

- (NSMutableDictionary *)members {
    TDAssert(_params);
    return _params;
}

@end
