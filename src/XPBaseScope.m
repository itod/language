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

- (instancetype)init {
    self = [self initWithEnclosingScope:nil];
    return self;
}


- (instancetype)initWithEnclosingScope:(id <XPScope>)outer {
    self = [super init];
    if (self) {
        self.enclosingScope = outer;
        self.symbols = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void)dealloc {
    self.enclosingScope = nil;
    [super dealloc];
}


- (id <XPScope>)getParentScope {
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
