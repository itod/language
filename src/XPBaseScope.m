//
//  XPBaseScope.m
//  Language
//
//  Created by Todd Ditchendorf on 29.01.17.
//  Copyright © 2017 Celestial Teapot. All rights reserved.
//

#import "XPBaseScope.h"
#import "XPSymbol.h"

@interface XPBaseScope ()
@property (nonatomic, retain, readwrite) id <XPScope>enclosingScope;
@end

@implementation XPBaseScope

+ (instancetype)scopeWithEnclosingScope:(id <XPScope>)scope {
    return [[[self alloc] initWithEnclosingScope:scope] autorelease];
}


- (instancetype)init {
    self = [self initWithEnclosingScope:nil];
    return self;
}


- (instancetype)initWithEnclosingScope:(id <XPScope>)scope {
    self = [super init];
    if (self) {
        self.enclosingScope = scope;
        self.symbols = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.enclosingScope = nil;
    self.symbols = nil;
    [super dealloc];
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %@>", [self class], _symbols];
}


- (id <XPScope>)parentScope {
    return self.enclosingScope;
}


#pragma mark -
#pragma mark XPScope

- (NSString *)scopeName {
    NSAssert2(0, @"%s is an abstract method and must be implemented in %@", __PRETTY_FUNCTION__, [self class]);
    return nil;
}


- (void)defineSymbol:(XPSymbol *)sym {
    TDAssertMainThread();
    TDAssert(sym);
    TDAssert(_symbols);
    
    [_symbols setObject:sym forKey:sym.name];
    sym.scope = self;
}


- (XPSymbol *)resolveSymbolNamed:(NSString *)name {
    TDAssertMainThread();
    TDAssert([name length]);
    TDAssert(_symbols);
    
    XPSymbol *sym = [_symbols objectForKey:name];
    
    if (!sym) {
        sym = [self.parentScope resolveSymbolNamed:name];
    }
    
    return sym;
}

@end
